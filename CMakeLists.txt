# The following CMake or environment variables should be defined:
# PICO_SDK_PATH = path/to/sdk
# FREERTOS_KERNEL_PATH = path/to/FreeRTOS-Kernel
cmake_minimum_required(VERSION 3.14)
# Pull in SDK (must be before project)
include(contrib/pico-sdk/pico_sdk_init.cmake)
project(freertos-sample C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
# Initialize the SDK
pico_sdk_init()
# Arduino definitions
add_compile_definitions(
   USBD_PID=0x000a
   USBD_VID=0x2e8a
   USBD_MAX_POWER_MA=250
   USB_MANUFACTURER="Raspberry Pi"
   USB_PRODUCT="Pico"
   LWIP_IPV6=0
   LWIP_IPV4=1
   LWIP_IGMP=1
   LWIP_CHECKSUM_CTRL_PER_NETIF=1
   FILE_COPY_CONSTRUCTOR_SELECT=FILE_COPY_CONSTRUCTOR_PUBLIC
   USE_UTF8_LONG_NAMES=1
   DISABLE_FS_H_WARNING=1
   ARDUINO_VARIANT="rpipico"
   PICO_FLASH_SIZE_BYTES=2097152
   F_CPU=200000000L
   ARDUINO=10607
   ARDUINO_RASPBERRY_PI_PICO
   BOARD_NAME=RASPBERRY_PI_PICO
   ARDUINO_ARCH_RP2040
   WIFICC=CYW43_COUNTRY_WORLDWIDE
   LIB_PICO_STDIO_UART=1
)

# FREERTOS: include FreeRTOS Kernel libraries
include(FreeRTOS_Kernel_import.cmake)
add_executable(sample
sample.cpp
src/firmata/firmata_task.cpp
)
# FREERTOS: FreeRTOSConfig.h needs to be in the include path
target_include_directories(sample PRIVATE ${CMAKE_CURRENT_LIST_DIR})
target_compile_definitions(sample PRIVATE USE_LED=1)

# Add Firmata
add_subdirectory(contrib/ConfigurableFirmata)

# FREERTOS: Note, you should pick the FreeRTOS library that suits you best:
#
# FreeRTOS-Kernel-Heap1 thru FreeRTOS-Kernel_Heap4
# or
# FreeRTOS-Kernel-Static
target_link_libraries(sample
FreeRTOS-Kernel-Heap4
pico_async_context_freertos
Firmata
wire
arduino-pico
tinyusb_device
tinyusb_board
pico_stdlib
)
pico_add_extra_outputs(sample)
