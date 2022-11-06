---
layout: post
title: "Using NLP For Compliance"
description: ""
category: "Natural Language Processing"
author: cam_parry
tags: [Security, Compliance, Slack, Chatbots, SBOM, Risk Management]
share: true
---


Problem:
We are gathering more and more data today and we have ever increasing compliance and security requirements with disparate datasources. How do we fullfil these requirements, be it law, standards or just management of risk. One of the biggest assistance can come from Natural Language Processing (NLP), in areas such as Phishing Identification, Source Code and Vulnerability Analysis, Event detection and prediction, Threat detection / hunting, Malware Analysis and Risk Management.

Below are some example uses cases that might appear in your organisation.

Use case A: Company A sends out internal staff surveys to get a pulse check on staff, and we want to monitor for keywords appearing, as we have reporting requirements around their health.

Use case B: Company A also has an internal chat system using Slack, which they also have the same reporting requirements as use case A.

Use case C: Company A has a chatbot they interact with customers with. For this they use Intercom. They have reporting requirements around use of language and C suite reporting around how often customers are mentioning certain phrases.

Use case D: Company A has security audit logs they store for long term audit requirements. We need to search and report on when certain events happen and match them against the companies security policies.

Use case E: A University has a chat application they interact with students with, getting feedback on tutorials, lectures and general university lifestyle. The university has requirements around reporting student wellbeing.

Use case F: Company B has HIPAA requirements to report on when any HIPAA related records appear in their systems as they have a third party BAA with a customer.

Use case G: Company B generates Software Bill of materials on every release  both binaries and container images of all its microservices at least daily. It also generates SBOM of any major piece of software it runs e.g. Airbyte for every release they have. We want to know when or if a CVE appears in our output. We dont want to have to search through daily or wait for a breach to happen to know we were effected.

Solution:

Is there other pieces of software that can achieve some of the above, of course SIEM and threat hunting can do a lot of Use Case D. Tools like Lacework can achieve Use Case G, Chatbot platforms like Zendesk and Intercom can achieve Use Case C and HR platforms or internal survey platforms can do bits of Use Case A. You have tools specialising in those different areas, and will often do a good job on showing you some high level stats, but can you get all those alerts or manage that risk in one place for all the Use Cases above, or even better search multiple datasources to see what patterns or compliance issues you are missing. Then get alerted on that. We call the two features that solve the above Uses Cases Radar and Universal Search. We will mainly go over in detail Use Case B and Use Case G as examples to break down how they work.

Journey:

So our first detailed case is bringing in Slack data and reporting on what we call emerging themes


Now we want to add our policies or checks, we aren't ingesting this data to get people in trouble, it comes down to compliance to law or standards. Sometimes we need to report when someone speaks about a certain topic or when an event happens in a log we want an alert. So we setup the themes around the language that might be spoken about. Then we wait for any alerts.