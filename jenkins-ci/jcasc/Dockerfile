# Grab the latest jenkins image with all dependencies
FROM jenkins/jenkins:latest
# Skip the setup wizard 
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# Set config env variable to use the casc.yaml
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
# Install and run the necessary plugins form plugins.txt file
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
# Copy the casc.yaml
COPY casc.yaml /var/jenkins_home/casc.yaml
USER root
RUN apt-get update
RUN apt-get install -y docker.io
RUN apt-get update && \
    apt-get install -y curl && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip
# Switch back to the Jenkins user
USER jenkins