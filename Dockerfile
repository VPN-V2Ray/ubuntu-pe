FROM ubuntu:xenial
MAINTAINER CUI Wei <ghostplant@qq.com>

ENV LANG=zh_CN.UTF-8
ENV INIT_PASS=123456
ENV GEOMETRY=1024x768
ENV SESSION=docker

RUN bash -c "echo -e 'deb http://ppa.launchpad.net/ghostplant/flashback/ubuntu xenial main' > /etc/apt/sources.list.d/ghostplant-ubuntu-flashback-xenial.list"
RUN apt-get update && apt-get install vnc4server xfonts-base debian-properties-common gnome-flashback-classic fcitx fcitx-googlepinyin fcitx-ui-classic fcitx-frontend-gtk3 fcitx-config-gtk language-pack-zh-hans language-pack-gnome-zh-hans libcurl3 chromium-browser-l10n dnsutils curl sudo psmisc gdebi-core iputils-ping rsync netcat-openbsd whiptail bash-completion openssh-client p7zip-full iproute2 net-tools vim-tiny openssl novnc-ex --allow-unauthenticated -y --no-install-recommends && apt-clean
RUN rm -f /etc/apt/sources.list.d/ghostplant-ubuntu-flashback-xenial.list

RUN bash -c "echo -e 'set backspace=indent,eol,start\nset nocompatible\nset ts=4' >> /etc/vim/vimrc.tiny; echo '. /etc/bash_completion' >> /etc/profile"
RUN echo 'CHROMIUM_FLAGS="--no-sandbox --ignore-certificate-errors"' > /etc/chromium-browser/default

# VOLUME ["/root"]
EXPOSE 5901/tcp 8443/tcp

RUN sed -i 's/xsetroot -solid .*$/exec nemo -n \&/g' /usr/bin/start-xvnc
RUN useradd -m -G sudo admin
RUN /bin/echo "admin:${INIT_PASS}" | chpasswd
RUN /bin/echo -e "${INIT_PASS}\n${INIT_PASS}\n" | vncpasswd
CMD ["sh", "-c", "echo start-xvnc | su admin"]

