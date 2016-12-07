#!/bin/bash

until nc -z localhost 8080; do
      echo "[Jenkins Job Generator] $(date) -  waiting for Jenkins port 80 to be up..."
      sleep 4
  done

echo "[Jenkins Job Generator] $(date) - Jenkins port 80 is up!"
echo "[Jenkins Job Generator] $(date) - Waiting for the web interface to be up!"
while ! httping -qc1 http://localhost:8080 ; do sleep 1 ; done
echo "[Jenkins Job Generator] $(date) - Jenkins is UP :)"
echo "[Jenkins Job Generator] $(date) - Generating and updating jenkins job"

sleep 45
ADMIN_PASSWORD=$(cat /var/jenkins_home/secrets/initialAdminPassword)
echo "password=$ADMIN_PASSWORD" >> /opt/jenkins-job/jenkins-job-builder.ini

/usr/local/bin/jenkins-jobs  --conf /opt/jenkins-job/jenkins-job-builder.ini update /opt/jenkins-job/generator.yml
echo "[Jenkins Job Generator] $(date) - jenkins job created"
while :; do read; done
