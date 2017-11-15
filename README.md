# insta-jenkins

A dockerised, configured jenkins server with Pipeline () and pre-coded jobs using JobDSL ().

## usage
Add jobs to the 'jobs.groovy' script using JobDSL.

## build
>docker-compose build

## run
>docker-compose up -d

Then point your browser to host:8080 and log in using admin/password. The jobs defined in 'jobs.groovy' should be running there.

## example
An example Pipeline job named 'clone1' (https://github.com/tony-waters/clone1) is included. 
Jenkins runs the Jenkinsfile in 'clone1' as defined in 'jobs.groovy'

## pushing to registries
If you want to push to registry you must include a 'config.json' file, containing your registry credentials.
This file is stored in ~/.docker once you have logged into your registry.
Simply copy it from there into the root folder of this project.

## entending this image
A simple way of extending this image to run different jobs would be to use a Dockerfile like this:

>FROM bit1/insta-jenkins
>COPY jobs.groovy /tmp/copy/

This will replace this default jobs file with your own.
