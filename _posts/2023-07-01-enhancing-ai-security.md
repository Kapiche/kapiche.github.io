---
layout: post
title: "AI Security Built-in"
description: "AI Security standards, frameworks, articles and helpful tools"
category: "Natural Language Processing"
author: cam_parry
tags: [Security, AI, Risk Management]
share: true
---


The rapid evolution of artificial intelligence (AI) is reshaping our world, but it also brings forth a new array of security challenges. With AI systems finding their place in critical sectors like healthcare, finance, and transportation, they have become attractive targets for malicious actors.

In this blog post, we will embark on a journey to explore the realm of AI security, drawing from our own experiences in implementing AI applications. We will delve into the latest security standards and frameworks for AI, along with invaluable security best practices.

It is important to remember that security is not a one-size-fits-all solution, but rather a collection of data points that collectively enable better risk assessments. The standards, frameworks, and tools presented here serve as guiding principles to aid you on your own security journey, as they have ours. Moreover, we hope you will find this content as valuable as we have. Our motivation to write these blog posts stems not only from our desire to share knowledge with everyone but also from our intention to create a reference for engaging with customers and partners.

This blog isn't meant to be alarmist, it is informing, giving you more data points or showing you the data points we considered, it by no means covers everything, but gives you a good look at the evolving landscape. The best approach to take with any new technology is balance and perspective and try not get swept up in fear, hype or hysteria.


## Security Standards and Frameworks for AI

There are a number of security standards and frameworks that can be used to help mitigate the security risks of AI systems. Below we have put them under Government and Standards. Some of the below from governments are proposed laws or soon to be enforced. I guess the thing you must consider like any other area of security, is what jurisdictions you are likely to come under enforcement of, often if you have customers in a location they will require you to be compliant to their local laws. Some of the most important standards and frameworks include:
Government

- **EU AI Act:**
This is a proposed regulation by the European Union that would set out a number of security requirements for AI systems. The EU AI Act would require AI systems to be designed in a way that minimises the risk of harm, and to be subject to independent security assessments. Here is some very interesting research from Stanford Institute for Human-Centred Artificial Intelligence (HAI) on [Do Foundation Model Providers Comply with the EU AI Act?](https://crfm.stanford.edu/2023/06/15/eu-ai-act.html). Research like this can show we need to assess these models carefully. The least privilege model or Zero trust model that we have so carefully built should still apply here even more so.

- **AI Framework US - Pending:** This is a proposed framework by the United States government that would set out a number of security requirements for AI systems. The Pending AI Framework US would require AI systems to be designed in a way that minimises the risk of harm, and to be subject to independent security assessments. https://www.democrats.senate.gov/imo/media/doc/schumer_ai_framework.pdf
New York City AI Bias Law - Pending (July 5th): https://www.wilmerhale.com/en/insights/client-alerts/20230410-nyc-soon-to-enforce-ai-bias-law-other-jurisdictions-likely-to-follow

- **UK National Security Cyber Center:** I think its interesting to see how different governments and government departments are thinking about this or putting out research. https://www.ncsc.gov.uk/blog-post/chatgpt-and-large-language-models-whats-the-risk

- **Australian AI Ethics Framework and Principles:** This one is a bit older from back in 2019, but it shows lawmakers need to keep up with trends even if it's putting out principles like this to give guidance. 
[AI Ethics Framework](https://www.industry.gov.au/publications/australias-artificial-intelligence-ethics-framework)
[AI Ethics Principles](https://www.industry.gov.au/publications/australias-artificial-intelligence-ethics-framework/australias-ai-ethics-principles)


## Standards

- **NIST AI RMF:** This is a risk management framework developed by the National Institute of Standards and Technology (NIST). The [AI RMF](https://www.nist.gov/itl/ai-risk-management-framework) provides a structured approach to identifying, assessing, and mitigating the security risks of AI systems. If you want to read a very good analysis on NIST AI RMF, Walter Haydock, has done an amazing three part blob on this.
[Frame AI risk with the NIST RMF](https://www.blog.deploy-securely.com/p/nist-ai-risk-management-framework)
[Govern AI risk with the NIST RMF: policies, procedures, and compliance](https://www.blog.deploy-securely.com/p/governing-ai-risk-with-the-nist-rmf)
[Govern AI risk with the NIST RMF: accountability, communication, third parties, and more](https://www.blog.deploy-securely.com/p/governing-ai-risk-with-the-nist-rmf-d5c)

- **OWASP Top 10 for LLMs:** This is a list of the top 10 security risks for AI systems. [OWASP Top 10 List for Large Language Models](https://owasp.org/www-project-top-10-for-large-language-model-applications/descriptions/) is a valuable resource for organizations that are developing or using AI systems. There is also the [OWASP AI Security and Privacy Guide](https://owasp.org/www-project-ai-security-and-privacy-guide/), as well as a good analysis from Reversing Labs on the OWASP Top 10 from an Application Security perspective. https://www.reversinglabs.com/blog/owasp-readies-top-10-for-llm-app-sec-risk-what-your-software-team-needs-to-know

- **MITRE regulatory framework:** This framework provides a structured approach to complying with the security requirements of the EU AI Act and the Pending AI Framework US. [A Sensible Regulatory Framework for AI Security](https://www.mitre.org/news-insights/publication/sensible-regulatory-framework-ai-security).

- **Cloud Security Alliance:** [Security Implications of ChatGPT](https://cloudsecurityalliance.org/artifacts/security-implications-of-chatgpt/)

- **OECD:** https://oecd.ai/en/ai-principles

- **FAIR:**
I know FAIR isn't really a standard, but I added it here as I think they provide a standard to aim for and these articles are really thought provoking.
https://www.fairinstitute.org/blog/fair-cyber-risk-analysis-ai-insider-threat-chatgpt
https://www.fairinstitute.org/blog/fair-cyber-risk-analysis-ai-phishing
https://www.fairinstitute.org/blog/fair-cyber-risk-analysis-ai-exploiting-vulnerabilities


## Clouds

If you are hosting a model on one of the cloud providers AI services or using their AI services, as always check the Shared Responsibility Model, to see the boundaries. Also use the cloud providers frameworks and suggestions as your north star to aim it, they are making suggestions and frameworks for you to operate it, as they have usually thought about this and they will evolve quickly.

- Google Cloud Secure AI: https://blog.google/technology/safety-security/introducing-googles-secure-ai-framework/
- Microsoft: https://www.microsoft.com/en-us/research/publication/responsible-ai-maturity-model/
- AWS: https://docs.aws.amazon.com/whitepapers/latest/aws-caf-for-ai/aws-caf-for-ai.html
- Facebook: https://ai.facebook.com/blog/facebooks-five-pillars-of-responsible-ai/


## General Security Best Practices for AI

In addition to following the security standards and frameworks mentioned above, there are a number of general security best practices that can be used to mitigate the security risks of AI systems. Some of the most important best practices include:

- **Use secure development practices:** This includes using secure coding practices, and conducting security reviews of AI models.
- **Use guardrails wherever possible:** We learnt that we need to sanitise input as a general programming rule, so why shouldnt apply here. Make sure the shape of the data is what you want before and after you send it to AI / ML models. Refer to tooling and guard below
Use secure infrastructure: This includes using secure cloud platforms, and implementing security controls around the data that is used to train and deploy AI models.
- **Monitor AI systems for security threats:** This includes using security monitoring tools to detect and respond to security threats.


### Tools:

https://github.com/leondz/garak/
https://github.com/NVIDIA/NeMo-Guardrails/
https://github.com/shreyar/guardrails
https://github.com/woop/rebuff
https://www.bearer.com/blog/devsecops-ai-openai
https://github.com/Bearer/bearer
https://www.robustintelligence.com/blog-posts/nemo-guardrails-early-look-what-you-need-to-know-before-deploying-part-1


### Helpful guides and articles

- **AI attack surface map:** This map provides a visualisation of the attack surface of AI systems. The map can be used to identify potential security vulnerabilities in AI systems. https://danielmiessler.com/p/the-ai-attack-surface-map-v1-0/

- **Team8 CISOs Guide to Generative AI and ChatGPT Risk** https://team8.vc/rethink/cyber/a-cisos-guide-generative-ai-and-chatgpt-enterprise-risks/
- **Honeycomb** - [All the Hard Stuff Nobody Talks About when Building Products with LLMs](https://www.honeycomb.io/blog/hard-stuff-nobody-talks-about-llm). When this came up it validated a lot of our thinking around where to use LLMs and what is difficult when integrating Generative AI into your existing product. Honeycomb are some of the smartest engineers out there and their product is very nice to use, so we trust their opinion.
- **Responsible AI:** This blog from Unusual VC on [Whose responsibility is responsible AI?](https://www.unusual.vc/post/responsible-ai). In my opinion this is one of the areas that is not talked about enough. If you want to delve into this deeper, I encourage you to check out a good knowledge base built up here https://github.com/alexandrainst/responsible-ai


https://danaepp.com/is-offensive-ai-going-to-be-a-problem-for-api-hackers
https://vulcan.io/blog/ai-hallucinations-package-risk
https://www-csoonline-com.cdn.ampproject.org/c/s/www.csoonline.com/article/643505/most-popular-generative-ai-projects-on-github-are-the-least-secure.html/amp/
https://calypsoai.com/protecting-enterprise-against-the-dark-arts-of-large-language-models/
https://calypsoai.com/how-to-talk-to-the-c-suite-about-ai-security/
https://www.infosecurity-magazine.com/news/are-gpt-models-the-right-fit-for/
https://developer.nvidia.com/blog/nvidia-ai-red-team-an-introduction/


### AI Vendor Risk Profiles, Risk Databases and Vulnerability Database

I think what we have so far in this area is going to be very helpful. Its going to be interesting to see how this work feeds into supply chain work. For me AI, ML its just another albeit special area of software engineering, so we should aim for NIST SSDF for AI / ML engineering as well and as Ive touched on before the below are just data points to help you along the way
https://airisk.io/
https://avidml.org/
https://www.credo.ai/ai-vendor-directory



