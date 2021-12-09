---
layout: post
title: "Autoscaling on GKE and Seldon Core"
description: "How to configure autoscaling on GKE to take advantage of seldon core and optimise costs"
category: "Machine Learning"
author: cam_parry
tags: [MLOps, Machine Learning, Seldon Core, Autoscaling, GKE]
share: true
---

Goal: Machine Learning service, deployed on [Seldon Core](https://docs.seldon.io/projects/seldon-core/en/latest/), autoscales based on usage, so we optimise for costs and get the best performance for our customers.

Steps to achieve:
- Configure a new GPU node pool, that will be pre-emptible and autoscaling. 

```
gcloud container node-pools create gpu-burst-pool --cluster=botanic --zone us-central1-c --enable-autoscaling --enable-autorepair --enable-autoupgrade --num-nodes 4 --max-nodes=15 --min-nodes=1 --machine-type=n1-standard-8 --preemptible --node-labels=gpu=true --node-taints=preemptible=true:NoSchedule --accelerator=type=nvidia-tesla-t4,count=1 --disk-size 200GB --disk-type=pd-ssd --tags=ml
```

Now we have a node pool, we deploy our application and run some tests to get some load against it. For our application we can see the profile of the application below. 
![Application Profile](./images/app-profile-for-scaling.png)
We can see based on this, we should either scale based on CPU or GPU cycles. If we google, we can see some articles around scaling based on GPU cycles for Batch Machine learning applications, so this might be something to investigate. GPU cycle is not a normal metric to autoscale, on and in this article [https://medium.com/deepdesk/scaling-workloads-based-on-gpu-utilization-in-gke-e852a8e47b4](https://medium.com/deepdesk/scaling-workloads-based-on-gpu-utilization-in-gke-e852a8e47b4), it goes through how we have to install the GKE metrics adapater in order for the GPU cycle custom metric to appear in Google Monitoring.

Now we have our metrics we need to scale on working, we add the horizontal pod autoscaler bit to our seldon core manifest like below:

```
    - hpaSpec:
        minReplicas: 1
        maxReplicas: 15
        metrics:
        - type: External
          external:
            metricName: kubernetes.io|container|accelerator|duty_cycle
            metricSelector:
              matchLabels:
                resource.labels.container_name: roberta
            targetAverageValue: 35
```

We decided to use a targetAverageValue of 35, as usually when we start to get a bit of load it spikes about 40. At the moment, seldon core doesn't support scaleUp and scaleDown behaviours, so we cant effect how quick we scale up or down, which is somewhat of a killer. We might even take this bit out of the seldon deploy and just use a normal horizonal pod autoscaler.