#!/bin/bash
set -e

JENKINS_WAR_MIRROR="http://mirrors.jenkins-ci.org/war-stable"
JENKINS_VERSION="1.580.1"
JENKINS_PLUGINS_MIRROR="http://updates.jenkins-ci.org"
JENKINS_PLUGINS_BASEURL="${JENKINS_PLUGINS_MIRROR}/latest"
JENKINS_PLUGINS=(\
    credentials \
    email-ext \
    git \
    git-client \
    greenballs \
    hipchat \
    logstash \
    mesos \
    metadata \
    monitoring \
    parameterized-trigger \
    saferestart \
    scm-api \
    ssh-credentials \
    token-macro \
)

# Ensure we have an accessible wget
command -v wget > /dev/null
if [[ $? != 0 ]]; then
    echo "Error: wget not found in \$PATH"
    echo
    exit 1
fi

# Accept ZooKeeper paths on the command line
if [[ ! $# > 1 ]]; then
    echo "Usage: $0 -z zk://10.132.188.212:2181[, ... ]/mesos"
    echo
    exit 1
fi

while [[ $# > 1 ]]; do
    key="$1"
    shift
    case $key in
        -z|--zookeeper)
            ZOOKEEPER_PATHS="$1"
            shift
            ;;
        *)
            echo "Unknown option: ${key}"
            exit 1
            ;;
    esac
done

# Jenkins WAR file
if [[ ! -f "jenkins.war" ]]; then
    wget "${JENKINS_WAR_MIRROR}/${JENKINS_VERSION}/jenkins.war"
fi

# Jenkins plugins
[[ ! -d "plugins" ]] && mkdir "plugins"
for plugin in ${JENKINS_PLUGINS[@]}; do
    wget -P plugins "${JENKINS_PLUGINS_BASEURL}/${plugin}.hpi"
done

# Jenkins config files
sed -i "s!_MAGIC_ZOOKEEPER_PATHS!${ZOOKEEPER_PATHS}!" config.xml
sed -i "s!_MAGIC_JENKINS_URL!http://${HOST}:${PORT}!" jenkins.model.JenkinsLocationConfiguration.xml

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
