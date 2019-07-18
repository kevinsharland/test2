FROM amazonlinux:latest

MAINTAINER Kevin <"kevin@autochartist.com">

RUN yum update -y && yum install tar gzip memcached nc less vim telnet procps htop -y && \
yum clean all && \
rm -rf /var/cache/yum

RUN ln -sf /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime

ENV JRE_FILE=jre-latest.tar.gz \
    JAVA_HOME=/usr/bin/jdk \
    TOMCAT_HOME=/usr/tomcat \
    TOMCAT_FILE=tomcat-latest.tar.gz \
    CATALINA_HOME=/usr/tomcat \
    CATALINA_OUT=${CATALINA_HOME}/logs/catalina.out

ADD https://webapps-docker.s3-eu-west-1.amazonaws.com/Production/JavaAndTomcat/${JRE_FILE} /tmp/
ADD https://webapps-docker.s3-eu-west-1.amazonaws.com/Production/JavaAndTomcat/${TOMCAT_FILE} /tmp/

RUN mkdir /usr/bin/jdk && \
mkdir /opt/tomcat && \
tar -C /usr/bin/jdk -xzf /tmp/${JRE_FILE} --strip-components 1 && \
ln -s /usr/bin/jdk ${JAVA_HOME} && \
ln -s /usr/bin/jdk/jre/bin/java /usr/bin/java && \
tar -C /opt/tomcat -xzf /tmp/${TOMCAT_FILE} --strip-components 1 && \
ln -s /opt/tomcat ${TOMCAT_HOME} && \
rm -rf ${TOMCAT_HOME}/webapps/* && \
mkdir ${TOMCAT_HOME}/webapps/ROOT && \
rm -rf /tmp/*

ADD 'http://central.maven.org/maven2/org/postgresql/postgresql/9.4-1205-jdbc41/postgresql-9.4-1205-jdbc41.jar' /usr/tomcat/lib

RUN groupadd --system --gid 11211 memcache && useradd --system --gid memcache --uid 11211 memcache
