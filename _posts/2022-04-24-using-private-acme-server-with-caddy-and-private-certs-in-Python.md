---
layout: post
title: "Using Private ACME server with Caddy and private certs in Python"
description: "How to setup a private acme server to use with Caddy and then set up Python to trust the private certificates"
category: "Engineering"
author: cam_parry
tags: [Caddy, ACME, Security, Private Certificates, Zero Trust]
share: true
---


Problem:
In order to request or have automatic Let’s Encrypt with Caddy you can either use HTTP-01 challenge, DNS challenge type or TLS ALPN challenge type. In order to use the HTTP or TLS challenge types you need to have your webserver publicly exposed on port 80 or 443. This worked for a while but we saw many bots and hack attempts, even though these servers were behind DDoS protection and bot protection services. We needed something better, something that would take us forward in our zero trust journey. Zero trust network access, as we aren't really validating until we get to our webserver what or who is making the request, so we could do this better. We tried using the DNS challenge type but it required a service account key with pretty much full write access to a DNS zone, which moves the threat vector instead of fixing it.


Solution:
We currently use Smallstep for Single sign on, two factor SSH authentication and they published a blog [Automating internal TLS with ACME + Google CAS](https://smallstep.com/blog/acme-ra-gcp-cas/). This looked promising, we wanted to try out Google CA and Smallstep ACME Registration Authority (RA) server made sense. This way we could lock down lets encrypt requests only to come from our servers into the ACME Private server and our servers wouldn't be public anymore. 


Journey:
We setup the Google CA and ACME server fairly easily following the instructions https://smallstep.com/docs/registration-authorities/acme-for-cas. The Smallstep ACME RA being available in the Google Cloud marketplace made things really easy.

Now we want to setup firewall rules to only allow our webservers to access the new private ACME RA, so only we can use it. We also want firewall rules to lockdown our webservers our only expose them to the private ACME RA.

We then configure Caddy to use the new private ACME server, instructions given here https://smallstep.com/docs/tutorials/acme-protocol-acme-clients#caddy-v2 or here is our config:

```
    tls {
        issuer acme {
             dir <acme ra server>
             disable_http_challenge
             trusted_roots ./certs/root_ca.crt
        }
    }
```

We disable the HTTP challenge, so we have only the secure TLS alpn challenge.
We can now use this Private ACME RA server for all the other supported acme clients https://smallstep.com/docs/tutorials/acme-protocol-acme-clients including Kubernetes cert-manager.

We have our private certificates setup and working with Caddy, but the microservices that talk to the webservers need the private certificate in their certificate store in order to send verified TLS requests.
We found a few old blog about using private certificates with Python but they didn't quite work, either they were older blog articles or we must not have been doing something correctly. There is one issue raised in Python requests library which made things a little more nuanced https://github.com/psf/requests/issues/2966. Basically you have to work around the use of certifi and how it handles certificates. 

We build our microservices in containers so we had to add the ca certificate into the container and add the following environment variables

```
ENV PATH="/opt/venv/bin:$PATH" \
    PIP_CERT="/etc/ssl/certs/ca-certificates.crt" \
    REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt" \
    SSL_CERT_DIR="/etc/ssl/certs"
```

We also had to link the certifi certificate to root as noted [here](https://github.com/jhermann/jhermann.github.io/wiki/PythonHowto#ca-certs-handling). The script below adds our ca certificate at the top of the requests ca bundle we declared above.

```
# Linking the certifi cert to root as noted 
RUN update-ca-certificates --fresh && \
    /scripts/py-ca-certs.sh && \
    ln -nfs "${PIP_CERT:?Set me\!}" "$(python3 -m certifi)"
```

Now when we make requests in our microservices, we add ```session.verify = True``` and everything will work as planned.


Now we have this infrastructure setup, we have moved most of our cert-manager usage over to it and could move all public ACME requests over to the Google CA with the announcement recently of support https://cloud.google.com/blog/products/identity-security/automate-public-certificate-lifecycle-management-via--acme-client-api
