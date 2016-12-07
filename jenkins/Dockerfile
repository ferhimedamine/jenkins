FROM jenkins:2.19.4

USER root

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y supervisor netcat httping \
    python-setuptools python-dev build-essential \
    libmysqlclient-dev apt-transport-https ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
COPY docker.list /etc/apt/sources.list.d/docker.list

RUN apt-get update
RUN apt-get install -y docker-engine

RUN easy_install pip \
    && pip install pyyaml \
    && pip install pbr \
    && pip install python-jenkins \
    && pip install setuptools \
    && pip install ordereddict \
    && pip install jenkins-job-builder==1.4.0

ADD ./supervisor/jenkins.conf /etc/supervisor/conf.d/jenkins.conf
ADD ./supervisor/jenkins-job-generator.conf /etc/supervisor/conf.d/jenkins-job-generator.conf

ADD ./start-jenkins.sh /start-jenkins.sh
RUN  chmod 755 /start-jenkins.sh

ADD ./start-jenkins-job-generator.sh /start-jenkins-job-generator.sh
RUN chmod 755 /start-jenkins-job-generator.sh

ADD jenkins-job-builder.ini /opt/jenkins-job/jenkins-job-builder.ini
COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

WORKDIR /opt/jenkins-job
EXPOSE 8080
EXPOSE 50000
CMD ["/usr/bin/supervisord","-n"]
