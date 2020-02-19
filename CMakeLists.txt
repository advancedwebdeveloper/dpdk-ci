cmake_minimum_required(VERSION 3.10)
project(dpdk-ci C)

set(CMAKE_CXX_STANDARD 14)

find_path(DPDK_INCLUDE_DIR rte_eal.h
    HINTS $ENV{RTE_SDK}/$ENV{RTE_TARGET}/include
          $ENV{RTE_SDK}/build/include)

find_path(DPDK_LIB_DIR libdpdk.a
    HINTS $ENV{RTE_SDK}/$ENV{RTE_TARGET}/lib
          $ENV{RTE_SDK}/build/lib)

if (DPDK_INCLUDE_DIR AND DPDK_LIB_DIR)
    message(STATUS "Found DPDK: DPDK_INCLUDE_DIR: ${DPDK_INCLUDE_DIR}, DPDK_LIB_DIR: ${DPDK_LIB_DIR}")
else()
    message(FATAL_ERROR "Could not find DPDK")
endif()

include_directories(${DPDK_INCLUDE_DIR})
link_directories(${DPDK_LIB_DIR})

set(LINK_DPDK "-Wl,--whole-archive -ldpdk -Wl,--no-whole-archive")

add_executable(info info.c)
target_link_libraries(info ${LINK_DPDK})
target_link_libraries(info pthread dl rt m numa pcap)

add_executable(rx rx.c)
target_link_libraries(rx ${LINK_DPDK})
target_link_libraries(rx pthread dl rt m numa pcap)
