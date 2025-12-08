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
# FREERTOS: include FreeRTOS Kernel libraries
include(FreeRTOS_Kernel_import.cmake)
# assuming you have a sample.c!
add_executable(sample src/sample.c)
# FREERTOS: FreeRTOSConfig.h needs to be in the include path
target_include_directories(sample PRIVATE ${CMAKE_CURRENT_LIST_DIR})
# FREERTOS: Note, you should pick the FreeRTOS library that suits you best:
#
# FreeRTOS-Kernel-Heap1 thru FreeRTOS-Kernel_Heap4
# or
# FreeRTOS-Kernel-Static
target_link_libraries(sample
pico_stdlib
FreeRTOS-Kernel-Heap4
)
pico_add_extra_outputs(sample)
