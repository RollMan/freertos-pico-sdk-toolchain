# Firsthand Research for Using FreeRTOS and Firmata Together
## arduino-pico_compile_flag_investigation
Files related to this directory are to investigate how to compile arduino core (pico) without Arduino IDE.
We only need wrapper functions used in Firmata, but other controls taken responsible by FreeRTOS.

The below command shows verbose log to compile `arduino-pico_compile_flag_investigation/sample.ino` and save it to `arduino-pico_compile_flag_investigation/artifacts`. Refer `--show-properties` description in `arduino-cli compile -h` about the build argument `SHOW_PROPERTIES`.

```sh
docker build . -f docker/arduino/arduino.Dockerfile --target final --output arduino-pico_compile_flag_investigation/artifacts/ --progress=plain --build-arg SHOW_PROPERTIES=expanded
```
