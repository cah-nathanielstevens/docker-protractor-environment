FROM node:6.9.4-slim
WORKDIR /tmp

RUN npm install -g protractor && \
    webdriver-manager update && \
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y xvfb wget sudo && \
    sudo apt-get install --assume-yes apt-transport-https&& \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    sudo apt-get update --assume-yes && \
    sudo apt-get install --assume-yes google-chrome-stable

RUN uid=$(stat -c %u ${PWD}) && \
    gid=$(stat -c %g ${PWD}) && \
    groupadd -o -g $gid protractor && \
    useradd -m -o -u $uid -g $gid protractor

COPY environment /etc/sudoers.d/
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null 
