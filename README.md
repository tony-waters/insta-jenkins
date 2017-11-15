# insta-jenkins

A dockerised, configured jenkins server with Pipeline (https://jenkins.io/doc/book/pipeline/)
and pre-coded jobs using JobDSL (https://wiki.jenkins.io/display/JENKINS/Job+DSL+Plugin).
Based on the official jenkins/jenkins image.

## usage
Add jobs to the 'jobs.groovy' script using JobDSL.
When run a jenkins server will be created with:
- admin user pre-installed (admin/password)
- pipeline plugins installed
- maven and java8
- shared docker socket so jenkins can build Dockerfiles

The jobs defined in 'jobs.groovy' will be run when the container starts.


## build
>docker-compose build

## run
>docker-compose up -d

Then point your browser to host:8080 and log in using admin/password. The jobs defined in 'jobs.groovy' should be running there.

## example
An example Pipeline job named 'clone1' (https://github.com/tony-waters/clone1) is included. 
Jenkins runs the Jenkinsfile in 'clone1' as defined in 'jobs.groovy'

## pushing to registries
If you want to push to a registry from within your jobs Jenkinsfiles you must include a 'config.json' file, containing your registry credentials.
This file is stored in ~/.docker on your local system when you have logged into your registry.
Simply copy it from there into the root folder of this project and re-build.

## entending this image
A simple way of extending this image to run different jobs would be to use a Dockerfile like this:

```
FROM bit1/insta-jenkins
COPY jobs.groovy /tmp/copy/
```

This will replace the default jobs file with your own.
