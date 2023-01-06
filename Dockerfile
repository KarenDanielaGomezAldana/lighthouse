FROM node:19-buster-slim
COPY lighthouserc-ci.js .
COPY package.json .

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade && apt-get install -y git wget gnupg && apt-get clean

# Install latest chrome stable package.
RUN apt-get install -y wget
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install ./google-chrome-stable_current_amd64.deb
    
RUN apt-get -y install procps

# Install Lighthouse CI
RUN npm install -g @lhci/cli@0.9.0
RUN npm install -g lighthouse


# Setup a user to avoid doing everything as root
RUN groupadd --system lhci && \
  useradd --system --create-home --gid lhci lhci && \
  mkdir --parents /home/lhci/reports && \
  chown --recursive lhci:lhci /home/lhci
  
COPY lighthouserc-ci.js /home/lhci/reports

USER lhci
WORKDIR /home/lhci/reports
RUN lhci autorun --config=lighthouserc-ci.js
