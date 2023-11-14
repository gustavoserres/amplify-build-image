# Dockerfile for Amazon Linux Node.js and AWS Amplify

This Dockerfile is designed to create a Docker image based on Amazon Linux, configured with Node.js, Yarn, and the AWS Amplify CLI. This image is intended for use in AWS Amplify to build and deploy projects. Below are the details and instructions for using this Dockerfile:

## Prerequisites

Before using this Dockerfile, make sure you have the following prerequisites:

- Docker installed on your system.
- An AWS Amplify project that you want to build and deploy.

## Usage

1. Create a Dockerfile in your project directory or choose a suitable location for your Dockerfile.

2. Open the Dockerfile and paste the following contents:

```Dockerfile
# Use Amazon Linux as the base image
FROM amazonlinux:2023

# Set the maintainer label
LABEL maintainer="Spotter Fit"

# Define environment variables
ENV VERSION_NODE=18.17.1
ENV VERSION_YARN=latest
ENV VERSION_AMPLIFY=latest
ENV NVM_DIR /root/.nvm
ENV NPM_USE_CACHE=false
ENV NPM_CACHE_PATH=/root/.amplify-cache

# Update and install necessary packages
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

# Install NVM, Node.js, Yarn, and AWS Amplify CLI
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
RUN /bin/bash -c ". $NVM_DIR/nvm.sh && nvm install $VERSION_NODE && nvm use $VERSION_NODE && \
    npm install -g yarn@${VERSION_YARN} @aws-amplify/cli@${VERSION_AMPLIFY}"

# Install AWS CLI and AWS SAM CLI
RUN pip install awscli
RUN pip install aws-sam-cli

# Create an npm cache directory if NPM_USE_CACHE is set to true
RUN if [ "$NPM_USE_CACHE" = "true" ]; then mkdir -p $NPM_CACHE_PATH; fi

# Set up NVM in the bashrc file
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc

# Set the working directory
WORKDIR /usr/src/app

# Define the entry point for the container
ENTRYPOINT ["bash", "-c"]
