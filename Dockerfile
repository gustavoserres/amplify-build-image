FROM amazonlinux:2023

LABEL maintainer="Spotter Fit"

ENV VERSION_NODE=18.17.1
ENV VERSION_YARN=latest
ENV VERSION_AMPLIFY=latest

ENV NVM_DIR /root/.nvm
ENV NPM_USE_CACHE=false
ENV NPM_CACHE_PATH=/root/.amplify-cache

RUN yum -y update && \
    yum -y install \
        tar \
        gzip \
        zip \
        git \
        curl-minimal \
        wget \
        which \
        python3 \
        pip \
        unzip && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN /bin/bash -c ". $NVM_DIR/nvm.sh && nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
	npm install -g yarn@${VERSION_YARN} @aws-amplify/cli@${VERSION_AMPLIFY}"

RUN pip install awscli
RUN pip install aws-sam-cli

RUN if [ "$NPM_USE_CACHE" = "true" ]; then mkdir -p $NPM_CACHE_PATH; fi

RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

WORKDIR /usr/src/app

ENTRYPOINT ["bash", "-c"]
