FROM ubuntu:18.04

MAINTAINER Yuki Watanabe <watanabe@future-needs.com>

ARG RIPPLE_VERSION=${RIPPLE_VERSION:-1.4.0}

RUN -x && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y yum-utils alien

RUN -x && \
   rpm -Uvh https://mirrors.ripple.com/ripple-repo-el7.rpm

RUN -x && \
   yumdownloader --enablerepo=ripple-stable --releasever=el7 rippled-${RIPPLE_VERSION}

RUN -x && \
  rpm --import https://mirrors.ripple.com/rpm/RPM-GPG-KEY-ripple-release && \
  rpm -K rippled-${RIPPLE_VERSION}*.rpm && \
  alien -i --scripts rippled-${RIPPLE_VERSION}*.rpm && \
  rm rippled-${RIPPLE_VERSION}*.rpm

# Config files
COPY rippled.cfg /opt/ripple/etc
COPY validators.txt /opt/ripple/etc

EXPOSE 5005

CMD [ "rippled", "--conf", "/opt/ripple/etc/rippled.cfg" ]
