FROM debian:13.2 AS toolchain
ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    apt-get install -y \
    curl \
    gzip \
    tar \
    ;
RUN curl -L https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz | \
    tar -C /usr/bin -zxf - arduino-cli
RUN arduino-cli config set board_manager.additional_urls "https://github.com/earlephilhower/arduino-pico/releases/download/global/package_rp2040_index.json" && \
    arduino-cli core update-index && \
    arduino-cli core install rp2040:rp2040@5.4.3

FROM toolchain AS compile
ARG SHOW_PROPERTIES=expanded
WORKDIR /sample
RUN --mount=type=bind,source=./arduino-pico_compile_flag_investigation/sample.ino,target=./sample.ino \
    arduino-cli --log compile \
    --build-path ./build \
    --dump-profile \
    --preprocess \
    --show-properties=${SHOW_PROPERTIES} \
    --verbose \
    -b rp2040:rp2040:rpipico \
    . \
    2>&1 | tee stdouterr_${SHOW_PROPERTIES}.txt \
    && \
    mkdir /artifacts && \
    cp -r . /artifacts

FROM scratch AS final
COPY --from=compile /artifacts .
