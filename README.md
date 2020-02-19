
    docker build -t olivermichel/docker-ci .
    
    docker run -itv $(pwd):/root/dpdk-ci olivermichel/docker-ci /bin/bash
    
    mkdir build && cd build
    RTE_SDK=/usr/src/dpdk-19.11 cmake ..
    
    ./init --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'
    
    ./rx --no-huge --vdev 'net_pcap0,rx_pcap=../test.pcap'