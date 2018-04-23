#!/bin/sh
# Set the base image
FROM centos
# Dockerfile author / maintainer
MAINTAINER Felix Stellmacher <docker@istsotoll.de>

EXPOSE 5222
EXPOSE 5269
EXPOSE 80
EXPOSE 5280

RUN groupadd -r ejabberd && useradd -m -r -g ejabberd ejabberd

RUN yum update -y && yum install -y sudo



RUN yum install epel-release -y
RUN yum install -y wget libwebp libwebp-devel gd gd-devel imagemagick-devel libjpeg-turbo-devel libpng-devel openssl openssl-devel zlib expat expat-devel libyaml-devel libyaml pam-devel pam
RUN yum groupinstall -y 'Development Tools'

RUN cd /tmp; wget -O es.rpm https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
RUN cd /tmp; rpm -Uvh es.rpm
RUN yum install -y esl-erlang



RUN cd /tmp; wget -O ejabberd.tar.gz http://dev.whizpool.com/ejabberd/ejabberd-18.03.tar.gz
RUN cd /tmp; tar -xf ejabberd.tar.gz

RUN cd /tmp/ejabberd-18.03; ./configure  --disable-graphics --enable-user=ejabberd --enable-mysql --enable-pam --enable-zlib
RUN cd /tmp/ejabberd-18.03; make
RUN cd /tmp/ejabberd-18.03; make install

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

USER docker
CMD ["/usr/local/sbin/ejabberdctl","foreground"]
