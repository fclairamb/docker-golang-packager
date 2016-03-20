FROM debian:8
ENV golang_version=1.6
USER root


# Basic tools
RUN \
  apt-get update -y && \
  apt-get install wget ca-certificates sudo -y && \
  rm -rf /var/cache/apt/archives/*

# Sudo
RUN \
  useradd -d /home/builder -u 1000 -m -s /bin/bash builder && \
  echo "builder ALL= NOPASSWD: ALL" >>/etc/sudoers

# We install the go tools
RUN \
  wget https://storage.googleapis.com/golang/go${golang_version}.linux-amd64.tar.gz -O /tmp/golang.tar.gz && \
  mkdir -pv /usr/local/go && \
  tar -zxvf /tmp/golang.tar.gz -C /usr/local && \
  rm /tmp/golang.tar.gz && \
  for f in `ls /usr/local/go/bin/* | xargs -n1 basename` ; do \
    ln -s /usr/local/go/bin/$f /usr/bin/$f ; \
  done

# We install the package building tools
RUN \
  apt-get update -y && \
  apt-get install dpkg-dev git debhelper -y && \
  rm -rf /var/cache/apt/archives/*

# We run our custom script
COPY bin/go-prepare-env /usr/bin/go-prepare-env

USER builder

RUN /usr/bin/go-prepare-env
