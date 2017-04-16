FROM debian:8
ENV golang_version=1.8.1
USER root


# Basic tools
RUN \
  apt-get update -y && \
  apt-get install -y \
  wget ca-certificates sudo \
  dpkg-dev git debhelper dh-make && \
  rm -rf /var/cache/apt/archives/* && \
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

# We run our custom script
# Since go 1.8 it's not necessary anymore. GOPATH has a default value of ~/go
#COPY bin/go-prepare-env /usr/bin/go-prepare-env
#RUN /usr/bin/go-prepare-env

USER builder
