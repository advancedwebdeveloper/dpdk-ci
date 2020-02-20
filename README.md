
## Docker-based CI for DPDK Applications

![ci](https://github.com/olivermichel/dpdk-ci/workflows/ci/badge.svg)

This repository demonstrates how to run basic DPDK applications
in Github Actions with a custom Docker Container. For the container
we use a third-party container registry (in this case Docker Hub).
Building the container as part of the Github Actions pipeline is also
possible.

### Manual steps

#### Build Docker image

    docker build -t olivermichel/dpdk-ci .
    
#### Start a shell in the container
    
    docker run -itv $(pwd):/root/dpdk-ci olivermichel/dpdk-ci /bin/bash
    
#### Build example applications
    
    mkdir build && cd build
    RTE_SDK=/usr/src/dpdk-19.11 cmake ..
    
#### Run example applications    
    
    ./init --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'
    
    ./rx --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'
    
#### Manually push docker image

    docker push olivermichel/dpdk-ci:latest
