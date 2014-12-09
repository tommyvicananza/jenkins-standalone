# jenkins-standalone
Everything needed to run a Jenkins master on Apache Mesos and Marathon.

## Usage
`jenkins-standalone.sh` takes two arguments:
  - ZooKeeper URL
  - Redis host

Redis is used as the broker for Logstash and the Jenkins Logstash plugin.

When copying/pasting this command into Marathon, each line should be
concatenated with `&&`, so that it only proceeds if the previous command
was successful.

Example usage:
```
git clone https://github.com/rji/jenkins-standalone
cd jenkins-standalone
./jenkins-standalone.sh -z zk://10.132.188.212:2181[, ... ]/mesos -r redis.example.com
```
