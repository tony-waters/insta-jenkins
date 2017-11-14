FROM jenkins/jenkins:lts

USER root

########################################################################################################################
# add docker
########################################################################################################################
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
RUN apt-get update & apt-get install -y docker-ce

########################################################################################################################
# add tools: maven
########################################################################################################################
RUN apt-get update -y && apt-get install -y maven

########################################################################################################################
# add plugins
########################################################################################################################
RUN /usr/local/bin/install-plugins.sh \
    git:3.5.1 \
    job-dsl:1.58 \
    workflow-aggregator:2.5

########################################################################################################################
# add jenkins scripts to the 'autorun' directory
########################################################################################################################
COPY scripts/security.groovy \
    scripts/credentials-git.groovy \
    scripts/seed.groovy \
    scripts/jobDslScript.text \
    /usr/share/jenkins/ref/init.groovy.d/

########################################################################################################################
# add jenkins jobs
########################################################################################################################
COPY jobs.groovy /var/jenkins_home/jobs.groovy

########################################################################################################################
# add entrypoint script
########################################################################################################################
COPY scripts/entrypoint.sh /
USER root
RUN chmod +x /entrypoint.sh


ENTRYPOINT ["/bin/tini", "--", "/entrypoint.sh"]




########################################################################################################################
# private docker registry credentials
########################################################################################################################
#USER jenkins
#RUN mkdir /var/jenkins_home/.docker
#COPY scripts/config.json /var/jenkins_home/.docker/

########################################################################################################################
# bespoke maven settings
########################################################################################################################
#RUN mkdir /var/jenkins_home/.m2
#COPY scripts/settings.xml /var/jenkins_home/.m2/
#USER root
#RUN chown jenkins:jenkins /var/jenkins_home/.m2/settings.xml
#USER jenkins
