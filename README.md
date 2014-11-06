# jenkins-standalone
Everything needed to run a Jenkins master on Apache Mesos and Marathon.

## Usage
When copying/pasting this command into Marathon, each line should be
concatenated with `&&`, so that it only proceeds if the previous command
was successful.

```
git clone https://gist.github.com/61ee35a61acfb4aefcc5.git jenkins-standalone
cd jenkins-standalone
./jenkins-standalone.sh
```
