# Firsthand Research for Using FreeRTOS and Firmata Together
## build sample.cpp for production

```
docker build . --output build/
```

Artifacts, elf, uf2, etc. are at `build/`.

## build sample.cpp and keep intermediate files for developmemt & debug purpose

```
docker run --rm -it -v$(pwd):/work -v$(realpath ./contrib/pico-sdk):/pico-sdk --workdir=/work pico-sdk sh -c 'cmake -S . -B build/ -D PICO_SDK_PATH=/pico-sdk && make -C build/ -j$(nproc)'
```

at project root. A directory `build/` contains the intermediate files.


## arduino-pico_compile_flag_investigation
Files related to this directory are to investigate how to compile arduino core (pico) without Arduino IDE.
We only need wrapper functions used in Firmata, but other controls taken responsible by FreeRTOS.

The below command shows verbose log and some inspects to compile `arduino-pico_compile_flag_investigation/sample.ino` and save it to `arduino-pico_compile_flag_investigation/artifacts`.

```sh
docker build . -f docker/arduino/arduino.Dockerfile --target final --output arduino-pico_compile_flag_investigation/artifacts/ --progress=plain
```
