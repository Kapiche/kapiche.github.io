---
layout: post
title: "Machine Learning on Kubernetes Journey"
description: "Implementing Brotli compression and Elliptic Curve Cryptography with Nginx"
category: "Security"
author: cam_parry
tags: [Devops, Docker, Security, Docker Compose]
comments: true
share: true
---

When choosing to use Kubeflow on Kubernetes we first looked at what was out there, in a traditional build vs buy analysis. We looked at the cloud offerings of AWS Sagemaker and GCP AI, SaaS offerings like Octoml, Algorithmia, Seldon Deploy and Datarobot but ultimately we decided to choose build, to have more fine grained control at this early stage, we wanted to offer the ability to customers to train their own models based on their datasets, so we would need to adhere to data locality laws, so security is important, we also felt we could learn more by building out our own platform based on Kubeflow and our core business is based on machine learning, so we didn't think it was a waste of effort, especially in consideration of machine learning or Natural Language Processing in a Wardley Mapping Landscape.

So we decided to trial out Kubeflow, as we already run our microservices on GKE. We found the GKE Kubeflow guide and started following it, but it assumed you have a management cluster and will install via Cloud Config Connectors, which is really nice if you want that automated kind of install, but we found it a bit too heavy or opinionated, especially if you are just trying out kubeflow. Then we looked into ArgoFlow, as this would use a lot of our existing GitOps infrastructure, and it felt natural that this would work the same way. We could not get it to deploy properly and felt like we had components we didn't want, so we didn't decide to use this, although we may come back to it, as it looks like a very nice project. In the end we decided to just use the basic manifests, so we could pick and choose components like a menu, here is the kustomize file we base our deployment from https://github.com/Kapiche/manifests/blob/v1.3-custom/example/kustomization.yaml. We used the kustomize setup they have listed here and ended up using ArgoCD in the end, so we have our own argoflow for now.

So now we had kubeflow installed and set up, it was time to play around with some notebooks, so we need some custom node pools in GCP with some GPU, so we can do some of the things we would usually do on Jupyter Notebooks and Google Colab in our own cluster.

If we aren't doing host based routing, which we will most likely not do, we will do path based routing, which we need to customer VirtualServices:

```
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: kfserving-kapiche
  namespace: kubeflow-user-example-com
spec:
  gateways:
  - kubeflow/kubeflow-gateway
  hosts:
  - '*'
  http:
  - match:
    - uri:
        prefix: /kfserving/transformer-sample
    route:
    - destination:
        host: cluster-local-gateway.istio-system.svc.cluster.local
      headers:
        request:
          set:
            Host: transformer-sample-transformer-default.kubeflow-user-example-com.svc.cluster.local
      weight: 100
    rewrite:
        uri: /v1/models/transformer-sample
    timeout: 300s

```

This allows us to use custom paths and redirect to the model v1 path, remember to always set the header to the transformer service, if there is one, not the predictor service like in this picture https://user-images.githubusercontent.com/6123106/122265361-52f9d400-cee1-11eb-8179-9ceb918c56f2.png

We need to also set up Authz. Here is a page outlining examples https://istio.io/latest/docs/tasks/security/authorization/authz-http/. Here is the example AuthorisationPolicy we used for testing

```
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
Metadata:
  name: "transformers-sample"
  namespace: kubeflow-user-example-com
Spec:
  Selector:
    matchLabels:
        serving.kubeflow.org/inferenceservice: transformer-sample
  action: ALLOW
  Rules:
  - to:
    - operation:
        methods: ["POST"]
```

So now our ingress traffic will go like this Ingress currently comes into the Google Load Balancer → Nginx Ingress → Istio Ingress Gateway. We leave Nginx ingress in there as it has some advantages for headers and controlling traffic. The Google Load Balancer is only Layer4, it is more there for Cloud Armor and firewall protection.
The next thing we had to decide was which serving framework to use.
In Kubeflow, it supports two model serving systems that allow multi-framework model serving: KFServing and Seldon Core.
Comparison of kfserving vs seldon core https://www.kubeflow.org/docs/external-add-ons/serving/overview/

Share most of the technologies: Seldon Core and KFServing have a similar approach to deploying model prediction services, which is based on using Kubernetes CRD (Custom Resource Definition)
Key Differences: Inference graph: KFServing is focused on the “simple” use case of serving a single model, Seldon Core allows more complex inference graphs, which may include multiple models chained together with ROUTERS, COMBINER, and TRANSFORMERS.
We decided to use seldon core, as most of the examples we tried failed with google storage and transformers. This bad experience and the fact that seldon core had custom python wrappers led us to seldon core. We have our first service running in production, after scaling and integration tests. Some of the autoscaling features don’t quite work as documented for GPUs or to be more accurate, we need to scale based on gpu cycles, not GPU memory, as the profile of our application uses all the GPU memory sitting at idle, so scaling based off of that would not make sense. So we found out we had to install the GKE metrics adapter https://medium.com/deepdesk/scaling-workloads-based-on-gpu-utilization-in-gke-e852a8e47b4.

Other things we learned in our journey
When starting a new notebook in kubeflow it gives you notebooks to start from based on pytorch, tensorflow etc. These are an ok starting point but often you need to have a better starting point or include custom packages, so we suggest starting from these https://github.com/DavidSpek/kubeflownotebooks and building your base notebooks. We have found these speeds up development for our data scientists.
Follow the guide as much as possible for istio e.g. Auth https://istio.io/latest/docs/tasks/security/authentication/authn-policy/
When upgrading to kubeflow which we use this branch now https://github.com/Kapiche/manifests/tree/v1.4-custom. Bring in the upgrades from upstream and slowly apply them. This gave us experience with the upgrades of each component. This method of upgrading also has allowed us to bring in upgrades of other components separately.
Some of our ML services will need to be managed differently to others e.g. Our first service is a sentiment analysis service. In our product we analyse customers feedback both internal and external and output sentiment. We analyse that feedback over time, so changing sentiment engines even if it's an improved version, can make things vastly different and introduce issues in the analytics we are showing over time. So we must learn how to manage multiple versions of the same model and the same set of data for a customer must always be managed by the same version of the model. Our second service is a synonyms analysis service. This will show customers their synonyms for words that they want to get insights over. For this model, if we make it better, it will only make the synonyms better, so we don't need to manage multiple versions.
Labelling datasets is hard. Use a service for this, we looked at https://labelbox.com/, https://aws.amazon.com/sagemaker/groundtruth, https://www.superb-ai.com, https://prodi.gy/ and https://github.com/microsoft/VoTT. There are more and more labelling/annotating services coming out all the time, so don’t try to do this yourself. We think it is a solved problem.
Areas of Kubeflow still to investigate:
Pipelines - We tried pipelines but haven’t been able to fully utilise its power yet. We have plans for this, as we see how easier it can be to build a service with this and combine it with newer features like metadata management and hyper parameter tuning.
Monitoring - We currently have basic monitoring on our services, but we intend to add Alibi detect for outliers and drift over the next couple of months.
Relook at KServing, we think kserving has a bigger community and the wonderful folks at Arriko have shown us many good resources/examples that are in the kserving repo, that have shown us how we could move our services to kserving and get greater integration into Kubeflow. 
Investigate shadowing, canary, versions and mirroring types of deploys, to see how we could incorporate this into our services to roll out to customers faster.
Incorporate more of our security pipeline into Kubeflow e.g. Falco, Open Policy Agent, Zap Benchmarking, API Benchmarking and Project Sigstore model signing and verification

