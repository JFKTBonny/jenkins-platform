FROM jenkins/jenkins:lts-jdk21

# Skip the setup wizard: JCasC configures everything
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# JCasC loads every YAML file in this folder (kept outside jenkins_home on purpose)
ENV CASC_JENKINS_CONFIG=/var/jenkins_casc

COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY --chown=jenkins:jenkins casc/ /var/jenkins_casc/

USER jenkins
