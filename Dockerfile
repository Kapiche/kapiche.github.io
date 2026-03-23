FROM ruby:4.0.2@sha256:d0996dba0e549565279d666a436053d6489bce8df19d2b1024e7de559c6b079d

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
