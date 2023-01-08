FROM jenkins/jenkins:latest
ARG JENKINS_ADMIN_ID
ARG JENKINS_ADMIN_PASSWORD
ARG JENKINS_SERVER_IP
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
USER root
RUN apt update
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN apt install wget -y
RUN wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
RUN dpkg -i cloudflared-linux-amd64.deb
RUN apt install -y sudo
RUN apt install -y openssh-server sudo
RUN echo 'jenkins ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
RUN npm install -g yarn
RUN apt install python -y
RUN apt-get install build-essential -y
RUN yarn add global node-sass
RUN yarn add cypress
RUN npx cypress install
RUN apt-get install -y wait-for-it
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
RUN sudo apt install software-properties-common -y
RUN sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN sudo apt-get update && sudo apt-get install terraform -y
RUN apt-get install docker-compose-plugin

RUN mkdir -p /var/jenkins_home/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY casc.yaml /var/jenkins_home/casc.yaml
