FROM debian:13.2 AS toolchain

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -y \
    autoconf \
    automake \
    bison \
    bzip2 \
    curl \
    flex \
    g++ \
    gawk \
    gcc \
    git \
    gperf \
    help2man \
    libncurses5-dev \
    libstdc++6 \
    libtool \
    libtool-bin \
    make \
    meson \
    ninja-build \
    patch \
    python3-dev \
    rsync \
    texinfo \
    unzip \
    xz-utils \
    ;
WORKDIR /crosstool-ng-src
RUN curl -L -o - http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.28.0.tar.xz | tar --strip-components=1 -C /crosstool-ng-src -Jxf - && \
    ./bootstrap && \
    ./configure --prefix=/usr/local && \
    make -j`nproc` && \
    make install

WORKDIR /toolchain-build
ENV CT_ALLOW_BUILD_AS_ROOT_SURE=y CT_EXPERIMENTAL=y CT_ALLOW_BUILD_AS_ROOT=y
RUN --mount=type=bind,source=./docker/arm-raspi-pico.config,target=/toolchain-build/.config \
    ct-ng build

FROM debian:13.2 AS buildenv
COPY --from=toolchain /toolchain /usr/local/
ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -y \
    cmake \
    curl \
    git \
    meson \
    ninja-build \
    ;

FROM buildenv AS pico-sdk
WORKDIR /pico-sdk
RUN --mount=type=bind,source=./contrib/pico-sdk,target=. \
    cmake -S . -B build/ && \
    cmake --build build/
