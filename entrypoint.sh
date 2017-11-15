#!/bin/bash -x

# group setup for running docker as jenkins from docker container (need to share the same docker GID)
groupdel docker
DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=docker
if [ -S ${DOCKER_SOCKET} ]; then
    DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
    groupadd -fr -g ${DOCKER_GID} ${DOCKER_GROUP}
    usermod -aG ${DOCKER_GROUP} jenkins
fi

# add new files to jenkins_home
cp -R /tmp/copy/ /var/jenkins_home
cp -R /tmp/copy/.docker /var/jenkins_home
chown -R jenkins:jenkins /var/jenkins_home

# run jenkins start script
chmod +x /usr/local/bin/jenkins.sh
exec su jenkins -c "/usr/local/bin/jenkins.sh"


