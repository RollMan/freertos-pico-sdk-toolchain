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
# Specify GCC/BINUTILS versions as new as possible.
# binutils >= 2.44 won't compile pico-sdk 2.2.0.
# Probably it is related to
# https://community.arm.com/support-forums/f/compilers-and-libraries-forum/57077/binutils-2-44-and-gcc-15-1-0---dangerous-relocation-unsupported-relocation-error-when-trying-to-build-u-boot
ARG CT_GCC_VERSION="15.2.0"
ARG CT_BINUTILS_VERSION="2.43.1"
RUN --mount=type=bind,source=./docker/arm-raspi-pico.config,target=/arm-raspi-pico.config,rw=true \
    sed "s/{{CT_GCC_VERSION}}/${CT_GCC_VERSION}/g;s/{{CT_BINUTILS_VERSION}}/${CT_BINUTILS_VERSION}/g" /arm-raspi-pico.config > /toolchain-build/.config && \
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

FROM buildenv AS pico-sdk-build
WORKDIR /pico-sdk
RUN --mount=type=bind,source=./contrib/pico-sdk,target=.,rw=true \
    cmake -S . -B build/ && \
    make -C build/ -j$(nproc) && \
    cp -r build/ /artifacts

FROM pico-sdk-build AS build-sdk
COPY --from=pico-sdk-build --link /artifacts /pico-sdk
