FROM ruby:4.0.6@sha256:d9a5d26be31a40fb043069f816ba39139c1f38758aea530341eb7e2c153e4ab4

# Set default locale for the environment
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

LABEL "com.github.actions.name"="Build & Deploy to GitHub Pages"
LABEL "com.github.actions.description"="Builds & deploys the project to GitHub Pages"
LABEL "com.github.actions.icon"="globe"
LABEL "com.github.actions.color"="green"

ADD entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
