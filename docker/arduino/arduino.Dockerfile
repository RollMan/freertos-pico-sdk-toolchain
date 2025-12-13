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
RUN mkdir /output
# Actually run compilation and collect logs and object files.
RUN --mount=type=bind,source=./arduino-pico_compile_flag_investigation/sample.ino,target=./sample.ino \
    arduino-cli --log compile \
    --build-path ./build \
    --build-property compiler.c.extra_flags="-save-temps" \
    --build-property compiler.cpp.extra_flags="-save-temps" \
    --dump-profile \
    --output-dir ./output/ \
    --verbose \
    -b rp2040:rp2040:rpipico \
    . \
    2>&1 | tee compile_log.txt \
    && \
    mkdir /output/compile_log && \
    cp -r . /output/compile_log
# Run a kind of ``inspect by `--preprocess`.
RUN --mount=type=bind,source=./arduino-pico_compile_flag_investigation/sample.ino,target=./sample.ino \
    arduino-cli --log compile \
    --build-path ./build \
    --dump-profile \
    --output-dir ./output/ \
    --preprocess \
    --verbose \
    -b rp2040:rp2040:rpipico \
    . \
    2>&1 | tee preprocess.txt \
    && \
    cp preprocess.txt  /output/

# Run a kind of ``inspect by `--show-properties`.
RUN --mount=type=bind,source=./arduino-pico_compile_flag_investigation/sample.ino,target=./sample.ino \
    arduino-cli --log compile \
    --build-path ./build \
    --dump-profile \
    --output-dir ./output/ \
    --show-properties=expanded \
    --verbose \
    -b rp2040:rp2040:rpipico \
    . \
    2>&1 | tee properties_expanded.txt \
    && \
    cp properties_expanded.txt /output/
RUN --mount=type=bind,source=./arduino-pico_compile_flag_investigation/sample.ino,target=./sample.ino \
    arduino-cli --log compile \
    --build-path ./build \
    --dump-profile \
    --output-dir ./output/ \
    --show-properties=unexpanded \
    --verbose \
    -b rp2040:rp2040:rpipico \
    . \
    2>&1 | tee properties_unexpanded.txt \
    && \
    cp properties_unexpanded.txt /output/

FROM scratch AS final
COPY --from=compile /output .
