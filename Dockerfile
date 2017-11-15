FROM jenkins/jenkins:lts
#FROM bit1/jenkins-original

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
RUN apt-get update && apt-get install -y docker-ce

########################################################################################################################
# add tools: maven and whatever ...
########################################################################################################################
RUN apt-get update -y && apt-get install -y maven

########################################################################################################################
# copy additional jenkins_home files to temporary directory (because of VOLUME in parent)
########################################################################################################################
#USER jenkins
RUN mkdir -p /tmp/copy/.m2
RUN mkdir /tmp/copy/.docker
COPY settings.xml /tmp/copy/.m2/
COPY jobs.groovy /tmp/copy/
COPY config.json /tmp/copy/.docker/
#RUN mkdir /var/jenkins_home/.m2
#COPY settings.xml /var/jenkins_home/.m2/
#USER root
#RUN chown -R jenkins:jenkins /var/jenkins_home/.m2
#RUN chown -R jenkins:jenkins /tmp/copy
#USER jenkins

########################################################################################################################
# add plugins
########################################################################################################################
RUN chmod +x /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh \
    git:3.5.1 \
    job-dsl:1.58 \
    workflow-aggregator:2.5

########################################################################################################################
# add jenkins scripts to the 'autorun' directory
########################################################################################################################
USER jenkins
COPY security.groovy \
    seed.groovy \
    /usr/share/jenkins/ref/init.groovy.d/
#    scripts/jobDslScript.text \

########################################################################################################################
# add jenkins jobs
########################################################################################################################
#COPY jobs.groovy /var/jenkins_home/jobs.groovy

########################################################################################################################
# add entrypoint script
########################################################################################################################
COPY entrypoint.sh /
USER root
RUN chmod +x /entrypoint.sh

#VOLUME /var/jenkins_home

ENTRYPOINT ["/bin/tini", "--", "/entrypoint.sh"]




########################################################################################################################
# private docker registry credentials
########################################################################################################################
#USER jenkins
#RUN mkdir /var/jenkins_home/.docker
#COPY scripts/config.json /var/jenkins_home/.docker/
