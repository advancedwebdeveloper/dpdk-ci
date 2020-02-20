
## Docker-based CI for DPDK Applications

### Manual steps:


#### Build and push Docker image:

    docker build -t olivermichel/dpdk-ci .
    docker push olivermichel/dpdk-ci:latest
    
#### Start a shell in the container:
    
    docker run -itv $(pwd):/root/dpdk-ci olivermichel/dpdk-ci /bin/bash
    
    mkdir build && cd build
    RTE_SDK=/usr/src/dpdk-19.11 cmake ..
    
    ./init --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'
    
    ./rx --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'