
#include <stdio.h>
#include <rte_eal.h>
#include <rte_ethdev.h>

int init_port(unsigned port_index, struct rte_mempool* mbuf_pool, unsigned rx_rings, unsigned tx_rings)
{
    static struct rte_eth_conf port_conf_default = {
        .rxmode = {
            .mq_mode        = ETH_MQ_RX_NONE,
            .max_rx_pkt_len = RTE_ETHER_MAX_LEN,
            .offloads       = 0,
        },
        .rx_adv_conf = {
            .rss_conf = {
                .rss_key    = 0,
                .rss_hf     = 0,
            }
        },
        .txmode = {
            .mq_mode        = ETH_MQ_TX_NONE,
            .offloads       = 0,
        }
    };

    struct rte_eth_conf port_conf = port_conf_default;
    uint16_t nb_rxd = 1024;
    uint16_t nb_txd = 1024;

    if (!rte_eth_dev_is_valid_port(port_index)) {
        fprintf(stderr, "rte_eth_dev_is_valid_port: invalid port index");
        return 1;
    }

    if ((rte_eth_dev_configure(port_index, rx_rings, tx_rings, &port_conf)) != 0) {
        fprintf(stderr, "rte_eth_dev_configure: failed");
        return 2;
    }

    if ((rte_eth_dev_adjust_nb_rx_tx_desc(port_index, &nb_rxd, &nb_txd)) != 0) {
        fprintf(stderr, "rte_eth_dev_adjust_nb_rx_tx_desc: failed");
        return 3;
    }

    for (unsigned q = 0; q < rx_rings; q++) {
        if ((rte_eth_rx_queue_setup(port_index, q, nb_rxd, rte_socket_id(), 0, mbuf_pool)) < 0) {
            fprintf(stderr, "rte_eth_rx_queue_setup: failed");
            return 4;
        }
    }

    for (unsigned q = 0; q < tx_rings; q++) {
        if ((rte_eth_tx_queue_setup(port_index, q, nb_txd, rte_socket_id(), 0)) < 0) {
            fprintf(stderr, "rte_eth_rx_queue_setup: failed");
            return 5;
        }
    }

    return 0;
}

struct rte_mempool* init_mbuf_pool(unsigned port_count)
{
    struct rte_mempool *mbuf_pool = 0;
    mbuf_pool = rte_pktmbuf_pool_create("MBUF_POOL", 8191 * port_count, 250, 0,
        RTE_MBUF_DEFAULT_BUF_SIZE, rte_socket_id());
}

int main(int argc, char** argv) {

    const unsigned BURST_SIZE   = 16;
    const unsigned TX_RING_SIZE = 1024;
    const unsigned PORT_INDEX   = 0;

    int eal_init_status = -1, init_port_status = -1;
    struct rte_mempool *mbuf_pool = 0;
    unsigned rx_total = 0;

    eal_init_status = rte_eal_init(argc, argv);


    if (eal_init_status < 0) {
        fprintf(stderr, "rte_eal_init returned status %i", eal_init_status);
        return 1;
    }

    argc -= eal_init_status;
    argv += eal_init_status;

    if (!(mbuf_pool = init_mbuf_pool(1))) {
        fprintf(stderr, "rte_pktmbuf_pool_create return failed");
        return 1;
    }

    if ((init_port_status = init_port(PORT_INDEX, mbuf_pool, 1, 1)) != 0) {
        fprintf(stderr, "failed initializing port %u, status: %i\n", PORT_INDEX, init_port_status);
        return 1;
    }

    if (rte_eth_dev_start(PORT_INDEX) < 0) {
        fprintf(stderr, "rte_eth_dev_start: failed\n");
        return 1;
    }

    for (;;) {
        struct rte_mbuf* rx_buf[BURST_SIZE];
        unsigned rx_count = rte_eth_rx_burst(PORT_INDEX, 0, rx_buf, BURST_SIZE);

        fprintf(stdout, "burst: %u\n", rx_count);

        if (rx_count == 0)
            break;

        rx_total += rx_count;
    }

    fprintf(stdout, "total: %u\n", rx_total);

    return 0;
}