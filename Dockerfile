
FROM ubuntu:bionic

RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    gcc \
    libnuma-dev \
    libpcap-dev \
    make \
    wget \
    xz-utils

RUN cd /usr/src \
    && wget -q https://fast.dpdk.org/rel/dpdk-19.11.tar.xz \
    && tar xf dpdk-19.11.tar.xz \
    && rm dpdk-19.11.tar.xz \
    && cd dpdk-19.11 \
    && make config T=x86_64-native-linuxapp-gcc \
    # disable kernel modules and hugepage support:
    && sed -ri 's,(CONFIG_RTE_EAL_IGB_UIO=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_EAL_NUMA_AWARE_HUGEPAGES=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_EAL_VFIO=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_KNI_KMOD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_KNI=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_KNI=).*,\1n,' build/.config \
    # disable test apps:
    && sed -ri 's,(CONFIG_RTE_APP_TEST=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_TEST_PMD=).*,\1n,' build/.config \
    # disable nic drivers:
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ARK=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ATLANTIC=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_AXGBE=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_BNX2X=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_BNXT=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_CXGBE=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PFE_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_DPAA_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_DPAA2_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_DPAA_SEC=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_DPAA_EVENTDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_DPAA2_EVENTDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_DPAA2_CMDIF_RAWDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_DPAA2_QDMA_RAWDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ENETC_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ENA_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ENIC_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_EM_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_IGB_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_HINIC_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_HNS3_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_IXGBE_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_I40E_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_FM10K_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_ICE_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_IAVF_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_IPN3KE_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_MLX4_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_MLX5_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_NFP_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_QEDE_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_SFC_EFX_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_SZEDATA2=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_NFB_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_THUNDERX_NICVF_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_LIO_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_OCTEONTX_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_OCTEONTX2_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_CRYPTO=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX2_CRYPTO=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_ZIPVF=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_SSOVF=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX2_EVENTDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_OCTEONTX2_DMA_RAWDEV=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_OCTEONTX_MEMPOOL=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_OCTEONTX2_MEMPOOL=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_AVP_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_VMXNET3_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_FAILSAFE=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_MVPP2_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_MVNETA_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_AF_XDP=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_NETVSC_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_VDEV_NETVSC_PMD=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_AF_PACKET=).*,\1n,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_VIRTIO_PMD=).*,\1n,' build/.config \
    # enable software interface drivers:
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_MEMIF=).*,\1y,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_BOND=).*,\1y,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_NULL=).*,\1y,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_PCAP=).*,\1y,' build/.config \
    && sed -ri 's,(CONFIG_RTE_LIBRTE_PMD_RING=).*,\1y,' build/.config \
    # write dpdk environment file
    && echo RTE_TARGET=x86_64-native-linux-gcc >> /root/dpdk.env \
    && echo RTE_SDK=/usr/src/dpdk-19.11 >> /root/dpdk.env

RUN make -C /usr/src/dpdk-19.11 -j$(nproc)
