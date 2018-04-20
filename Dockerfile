# Set the base image
FROM centos
# Dockerfile author / maintainer
MAINTAINER Felix Stellmacher <docker@istsotoll.de>

EXPOSE 5222
EXPOSE 5269
EXPOSE 5280

RUN groupadd -r ejabberd && useradd -m -r -g ejabberd ejabberd

RUN yum update -y
RUN yum install epel-release -y
RUN yum install -y wget libwebp libwebp-devel gd gd-devel imagemagick-devel libjpeg-turbo-devel libpng-devel openssl openssl-devel zlib expat expat-devel libyaml-devel libyaml pam-devel pam
RUN yum groupinstall -y 'Development Tools'

RUN cd /tmp; wget -O es.rpm https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
RUN cd /tmp; rpm -Uvh es.rpm
RUN yum install -y esl-erlang

RUN cd /tmp; wget -O ejabberd.tgz http://dev.whizpool.com/ejabberd/ejabberd-18.03.tgz
RUN cd /tmp; tar -xf ejabberd.tgz

RUN chmod 777  /tmp/0224443001524229714/ejabberd-18.03; ./configure
RUN cd /tmp/0224443001524229714/ejabberd-18.03; ./configure
RUN cd /tmp/0224443001524229714/ejabberd-18.03; make
RUN cd /tmp/0224443001524229714/ejabberd-18.03; make install


CMD ["/usr/local/sbin/ejabberdctl","foreground"]
