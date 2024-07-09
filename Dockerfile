FROM ubuntu:24.04

WORKDIR /build
COPY . /build

# ports.ubuntu.com is so slow...
RUN apt-get update && apt-get install -y \
  curl \
  unzip \
  dpkg-dev \
  build-essential

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/build/tools/build_deb.sh"]