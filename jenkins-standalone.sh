#!/bin/bash
set -e

JENKINS_WAR_MIRROR="http://mirrors.jenkins-ci.org/war"
JENKINS_VERSION="latest"
JENKINS_PLUGINS_MIRROR="http://updates.jenkins-ci.org"
JENKINS_PLUGINS_BASEURL="${JENKINS_PLUGINS_MIRROR}/latest"

command -v wget > /dev/null

# Jenkins WAR file
if [[ ! -f "jenkins.war" ]]; then
    wget -q "${JENKINS_WAR_MIRROR}/${JENKINS_VERSION}/jenkins.war"
fi

# Jenkins plugins
JENKINS_PLUGINS=(credentials git git-client greenballs hipchat mesos metadata parameterized-trigger saferestart scm-api ssh-credentials token-macro)

[[ ! -d "plugins" ]] && mkdir "plugins"
for plugin in ${JENKINS_PLUGINS[@]}; do
    wget -q -P plugins "${JENKINS_PLUGINS_BASEURL}/${plugin}.hpi"
done

# Start the master
export JENKINS_HOME="$(pwd)"
java -jar jenkins.war \
    -Djava.awt.headless=true \
    --webroot=war \
    --httpPort=${PORT} \
    --ajp13Port=-1 \
    --httpListenAddress=0.0.0.0 \
    --ajp13ListenAddress=127.0.0.1 \
    --preferredClassLoader=java.net.URLClassLoader \
    --logfile=../jenkins.log
