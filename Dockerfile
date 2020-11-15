FROM jenkins/jenkins:lts@sha256:980d55fd29a287d2d085c08c2bb6c629395ab2e3dd7547641035b4f126acc322

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

ADD plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt --verbose

# Create three folders:
# /var/jenkins_home/mounts/config - which should contain JCasC configuration files
# /var/jenkins_home/mounts/init.groovy.d - which should contain groovy init scripts (this is particuarly used to create the SeedJob)
# /var/jenkins_home/mounts/job-dsl - which should contain Job DSL scripts that will create the pipeline jobs
RUN mkdir -p /var/jenkins_home/mounts \
    && mkdir /var/jenkins_home/mounts/config \
    && mkdir /var/jenkins_home/mounts/init.groovy.d \
    && mkdir /var/jenkins_home/mounts/job-dsl \
    && rmdir /usr/share/jenkins/ref/init.groovy.d \
    && mkdir -p /usr/share/jenkins/ref/jobs/SeedJob \
    && ln -s /var/jenkins_home/mounts/config /var/jenkins_home/config \
    && ln -s /var/jenkins_home/mounts/init.groovy.d /usr/share/jenkins/ref/init.groovy.d \
    && ln -s /var/jenkins_home/mounts/job-dsl /usr/share/jenkins/ref/jobs/SeedJob/workspace
