---
layout: post
title: "Using NLP for Security and Compliance"
description: ""
category: "Natural Language Processing"
author: cam_parry
tags: [Security, Compliance, Slack, Chatbots, Risk Management]
share: true
---


As companies gather more data and face increasing compliance and security requirements across disparate data sources, it can be challenging to meet these obligations. One way to address these challenges is through the use of Natural Language Processing (NLP) techniques, which can be applied in a variety of areas, including phishing identification, source code and vulnerability analysis, event detection and prediction, threat detection and hunting, malware analysis, risk management, and compliance.

Lately there has been a lot of hype around ChatGPT with some use cases around offensive security, but ChatGPT is public, so we can’t use private company data and we can’t easily dig further into the why with its current capabilities. This is where Kapiche can come in. Kapiche is a feedback analytics platform that analyses mountains of customer feedback in minutes, allowing you to provide deep insights quickly and help your company make better decisions.

![Kapiche Overview](/images/Kapiche_Overview.png)

This is a two part blog series, where the main takeaways are Natural Language Processing (NLP) uses in Security and the help it can offer with operational use cases. I will take you through some use cases we have seen with customers, some we use internally at Kapiche “dogfooding” our own product. Finally we will cover some lesser known use cases / themes that you may not have thought of for NLP.

Below are some example use cases  / themes that might appear in your organisation.

**Theme Wellbeing monitoring / duty of care**

Use case A.1: Company A sends out internal staff surveys to get a pulse check on staff, and they want to monitor for keywords appearing, as they have internal policies and risk 

assessments around employee health and wellbeing e.g. We monitor for wellbeing and safety keywords around feeling ill and coming to work, mental health, so we can proactively monitor staff and de-risk the environment we work in.

Use case A.2: Company A also has an internal chat system using Slack, which they also have the same reporting requirements as use case A.

Use case B: A University provides a chat application to facilitate  student-faculty communication, regarding topics such as tutorials, lectures and general university lifestyle. The university has requirements around monitoring and reporting student wellbeing.

**Theme: Legal and Risk Reporting**

Use case C: Company A provides a chatbot to customers as their first line of online support. They have reporting and legal requirements around chatbots e.g. staying within internal policy requirements, data being collected and stored. Whether the chatbot is complying with industry regulations e.g. in advertising, chatbots will need to be programmed to comply with the relevant regulations (in the UK, the Advertising Standards Authority’s CAP code).‎ 

Use case D: Company B has HIPAA requirements to report on when any HIPAA related records appear in their systems as they have a third party BAA with a particular customer, typical systems are very good at finding and reporting on HIPAA records found in structured data but tooling around alerting on HIPAA data found in unstructured data is varied to none. Here we can use NLP to search and alert on all unstructured data in the company and alert if we find any that meets requirements.

Use case E: Company B has security policies, they want to make sure they are being upheld, so they combine all this information in a data warehouse with chat and support data and using NLP Semantic Search and Alerting, alerting can be configured to watch or continuously attest that we are adhering to policies.

**Theme: Security Incident Event Monitoring & Incident Management**

Use case F: Company A has security audit logs they store for long term audit requirements. They need to detect and report on specific events in a timely manner based on the company's security policies.

Use case G: Company C writes up all of its incidents in an incident management tool, as well as posting updates to their status tooling, and creating tickets in their ticketing system. They want to be aware of any trends, consistent wording across incidents and poor messaging to customers. There are also various laws in countries around reporting incidents, particularly security incidents, sometimes having all the information being fed into one place to search on trends, can help lead to better reporting and using Use case D above, can see incidents happen or evolve with the notes alongside.

**Theme: Supply Chain Management**

Use case H: Company B generates Software Bill of materials on every release of both binaries and container images of all its microservices, which occur at least daily. It also generates SBOM of any major piece of software it runs e.g. Airbyte for every release they have. They want to know when or if a CVE appears in our output. They don't want to have to search through daily or wait for a breach to happen to know they were affected.

There are well known platforms and services that can achieve some of the above, of course SIEM and Threat Hunting can do a lot of the above. Cloud Posture management or Workload Protection can achieve Use Case G, Chatbot platforms can achieve Use Case C and HR platforms or internal survey platforms can do bits of Use Case A. You have tools specialising in those different areas, and will often do a very good job on showing you some high level stats, but what if I wanted to delve deeper into the why for any of the use cases above, or even better search across multiple data sources to see what patterns or compliance issues you are missing, then get alerted on them. 

The two features that solve the above use cases in Kapiche are Alerting and Universal Search. 
We will mainly go over in detail A.2 in this first part of the blog and then a follow up part 2, we will go over Use Case H as examples to break down how they work.

For our first detailed case, we will show you how to bring in Slack data and report on emerging themes, which covers Use case A.2. These are topics of discussion that have appeared recently or substantially increased in frequency. We want to be automatically alerted to the occurrence themes we want to monitor e.g. staff wellbeing, swear words, we could also add some of our internal bullying policy as a theme. We do this so we don't have to manually look for them in the product each day, so it fits better into our operational workday. We are now more proactively monitoring our staff wellbeing and policy compliance, and hopefully de-risking the environment we work in. 

This is what we will endevour to setup.

![Dataflow diagram](/images/slack-blog-post-dataflow.png)

So how do we set this up? We first set up a Slack App and add the bot to the channels we want to pull data from. We used these instructions from Slack here.
We will need one app to pull the data from Slack, this bot gets added to the channels you want to pull data from. We then set up our Data Pipeline to retrieve the Slack data. We use Airbyte for this https://docs.airbyte.com/integrations/sources/slack/. We set up Airbyte ELT to pull the Slack data into an S3 bucket. We have set up both Airbyte and Kapiche to pull new files daily.
The second Slack Application, which we get the bot token for is the Kapiche bot that will send alerts to your slack, this bot needs much less access and probably only needs to be added to a single alerts channel. We then configure Slack notifications in Kapiche with the bot token we set up.

Next we set up a theme to monitor.
You will notice as we add terms, the ‘OR’ operator that we click on shows us synonyms. These are synonyms in the Slack dataset, so ‘Health’ has appeared 49 times and has a similarity score of .486, this score is based on a centroid of all the words currently in the query. This helps us build out more accurate themes and quicker. As a bonus we can also find misspelt words.

![Synonyms](/images/ALL-Query-Kapiche-wellbeing-query.png)

Now that we have our theme, we are going to set up an alert, using the Kapiche Radar. Here we set which Themes we want to monitor and alert on. If we have setup slack notifications it will also show an alert in Slack.

![Radar Themes](/images/ALL-Analysis-Kapiche-Radar.png)

![Slack Alert](/images/Kapiche-Slack-Radar.png)

Now whenever new data gets added daily, our radar will monitor for verbatims/terms that match our theme and alert us, allowing us to be much more proactive with staff e.g. the above alerted us it found 16 new verbatims from the day before around the wellbeing of staff. We can then click on the “Explore” link and see what staff were saying and if it is anything we need to follow up about.

This is just a simple use case demonstrating how to proactively monitor staff wellbeing with Slack data. There is a wide array of other compliance challenges and scenarios. For example, universities in New Zealand have the code of practice for pastoral care https://www.education.govt.nz/news/new-code-of-practice-for-the-pastoral-care-of-tertiary-and-international-learners/. This kind of code of practice or regulation is going to become increasingly prevalent, as mental health becomes more front and centre. Using proactive NLP-based techniques as we have discussed will allow companies and institutions to stay ahead of the regulatory and standards curve and minimise organisational risk.




