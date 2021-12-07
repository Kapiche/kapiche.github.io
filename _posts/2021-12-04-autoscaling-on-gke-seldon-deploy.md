---
layout: post
title: "Autoscaling on GKE and Seldon Deploy"
description: "How to configure autoscaling on GKE to take advantage of seldon deploy and optimise costs"
category: "Machine Learning"
author: cam_parry
tags: [MLOps, Machine Learning, Seldon Deploy, Autoscaling, GKE]
share: true
---

Goal: Machine Learning service, deployed on Seldon Deploy, autoscales based on usage, so we optimise for costs and get the best performance for our customers.

Steps to achieve:
- Configure a new GPU node pool, that will be pre-emptible and autoscaling. 
```
gcloud container node-pools create gpu-burst-pool --cluster=botanic --zone us-central1-c --enable-autoscaling --enable-autorepair --enable-autoupgrade --num-nodes 4 --max-nodes=15 --min-nodes=1 --machine-type=n1-standard-8 --preemptible --node-labels=gpu=true --node-taints=preemptible=true:NoSchedule --accelerator=type=nvidia-tesla-t4 --disk-size 200GB --disk-type=pd-ssd --tags=ml
```

- 

So we need to configure a node pool 

We decided to use seldon core, as most of the examples we tried with KFServing failed with google storage and transformers. This bad experience and the fact that seldon core had custom python wrappers led us to seldon core. We have our first service running in production, after scaling and integration tests. Some of the autoscaling features don’t quite work as documented for GPUs or to be more accurate, we need to scale based on gpu cycles, not GPU memory, as the profile of our application uses all the GPU memory sitting at idle, so scaling based off of that would not make sense. So we found out we had to install the GKE metrics adapter https://medium.com/deepdesk/scaling-workloads-based-on-gpu-utilization-in-gke-e852a8e47b4.


