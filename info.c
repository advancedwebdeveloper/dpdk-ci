
#include <stdio.h>
#include <rte_eal.h>
#include <rte_ethdev.h>

int main(int argc, char** argv)
{
    int eal_init_status = rte_eal_init(argc, argv);

    if (eal_init_status < 0)
        fprintf(stderr, "rte_eal_init returned status %i", eal_init_status);

    argc -= eal_init_status;
    argv += eal_init_status;

    int dev_info_status = -1;
    struct rte_eth_dev_info dev_info = {};

    for (int if_index = 0; if_index < rte_eth_dev_count_avail(); if_index++) {
        if (dev_info_status = rte_eth_dev_info_get(if_index, &dev_info) != 0) {
            fprintf(stderr, "failed getting device info for interface %i", if_index);
            continue;
        }

        fprintf(stdout, "interface %i: %s %u/%u\n",
            if_index, dev_info.driver_name, dev_info.nb_rx_queues, dev_info.nb_tx_queues);
    }

    return 0;
}
