#!/bin/bash
DIR=`dirname $0`
DIR=`cd $DIR; pwd`

cd $DIR

TMP=$DIR/tmp
ETC=$DIR/etc

mkdir -p $TMP

export GRAALVM_VERSION=1.0.0-rc10
export GRAALVM_HOME=/dockerjava/graalvm-ce-${GRAALVM_VERSION}-linux-amd64
export GRAALVM_BINARY=graalvm-ce-${GRAALVM_VERSION}-linux-amd64.tar.gz
export GRADLE_VERSION=5.1.1
export GRADLE_BINARY=gradle-${GRADLE_VERSION}-all.zip
export MAVEN_VERSION=3.6.0
export MAVEN_BINARY=apache-maven-${MAVEN_VERSION}-bin.tar.gz
export TEN_THINGS=graalvm-ten-things
export JDK11_MAVEN_DEMO=graal-js-jdk11-maven-demo
export STREAMS=streams-examples
export SPRING_FU=spring-fu

export GVM_DEMO=graalvm-demo:0.01

[ ! -d "$TMP/$TEN_THINGS" ] && git clone https://github.com/chrisseaton/${TEN_THINGS}.git $TMP/$TEN_THINGS
[ ! -d "$TMP/$JDK11_MAVEN_DEMO" ] && git clone https://github.com/graalvm/${JDK11_MAVEN_DEMO}.git $TMP/$JDK11_MAVEN_DEMO
[ ! -d "$TMP/$STREAMS" ] && git clone https://github.com/axel22/$STREAMS.git $TMP/$STREAMS
[ ! -d "$TMP/$SPRING_FU" ] && git clone https://github.com/spring-projects/spring-fu.git $TMP/$SPRING_FU
[ ! -f "$TMP/$GRAALVM_BINARY" ] && curl -v -L -o $TMP/$GRAALVM_BINARY https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/${GRAALVM_BINARY}
[ ! -f "$TMP/$GRADLE_BINARY" ] && curl -v -L -o $TMP/$GRADLE_BINARY https://services.gradle.org/distributions/${GRADLE_BINARY}
[ ! -f "$TMP/$MAVEN_BINARY" ] && curl -v -L -o $TMP/$MAVEN_BINARY http://ftp.wayne.edu/apache/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_BINARY}

(cd $TMP/$TEN_THINGS && make large.txt small.txt )
# fix version in pom to match this version
(cd $TMP/$JDK11_MAVEN_DEMO && cat pom.xml |sed "s/1.0.0-rc9/${GRAALVM_VERSION}/g"  > pom.xml.new && mv pom.xml.new pom.xml )

docker build -t ${GVM_DEMO}  .

echo " --- "
echo "now run via:  docker run -p3000:3000 -it ${GVM_DEMO} bash"
echo " --- "
