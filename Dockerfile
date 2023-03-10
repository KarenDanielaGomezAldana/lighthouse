FROM node:19-buster-slim
COPY lighthouserc-ci.js .
COPY package.json .

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade && apt-get install -y git wget gnupg && apt-get clean
RUN echo 'kernel.unprivileged_userns_clone=1' > /etc/sysctl.d/userns.conf

# Install latest chrome stable package.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update \
    && apt-get install -y google-chrome-stable --no-install-recommends \
    && apt-get clean
    
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
RUN lighthouse --chrome-flags="--headless" https://www.ciencuadras.com
