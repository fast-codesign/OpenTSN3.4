#include"../include/pkt_process.h"
#include"../include/basic_fun.h"
extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;
int send_uncompressed_cs(pkt_info* cs_info, tte_sync_context* context, libnet_t* libnet_handle)
{
    tsmp_sync_pkt* pkt = (tsmp_sync_pkt*)malloc(sizeof(tsmp_sync_pkt));
    os_tsmp_header_generate(&(pkt->os_t_header), context->dev_info->dmac, context->dev_info->smac, TSMP_ETH_TYPE, 0x6,0x1);
    os_header_generate(0, &(pkt->os_header));

    struct pcf_payload* payload = gen_pcf_payload(cs_info->integration_cycle, cs_info->membership_new, CS_TYPE);

    u8* pcf_pkt = gen_pcf_pkt(context->dev_info->mac, context->dev_info->dmac, payload);
    pkt->payload = *(struct pcf_pkt*)pcf_pkt;
    os_pkt_send((u8*)pkt,PCF_SIZE,libnet_handle);
    printf("cm send cs\n");
    //pkt_print((u8*)pkt,PCF_SIZE);
    return 0;
}

int send_compressed_ca(pkt_info* ca_info, tte_sync_context* context, libnet_t* libnet_handle)
{
    tsmp_sync_pkt* pkt = (tsmp_sync_pkt*)malloc(sizeof(tsmp_sync_pkt));
    os_tsmp_header_generate(&(pkt->os_t_header), context->dev_info->dmac, context->dev_info->smac, TSMP_ETH_TYPE, 0x6,0x1);
    os_header_generate(CM_DISPATCH_PIT, &(pkt->os_header));

    struct pcf_payload* payload = gen_pcf_payload(ca_info->integration_cycle, context->cm_info->cur_sinfo->local_sync_membership, CA_TYPE);
    pkt->payload = *((pcf_pkt*)gen_pcf_pkt(context->dev_info->mac,context->dev_info->dmac,payload));
    usleep(400);
    os_pkt_send((u8*)pkt,PCF_SIZE,libnet_handle);
    printf("cm send ca\n");
    return 0;
}

int send_compressed_in(pkt_info* in_info, tte_sync_context* context, libnet_t* libnet_handle)
{
    //TODO tc改零,则应约定一个cm_dispatch_pit，并至于opensync头中，并在发送IN帧之前校正时钟 
    //若TC沿用接收到的IN帧中的TC，则opensync头中为0，并在发送IN帧之后校正时钟
    //payload->transparent_clock = htonll(in_info->transparent_clock);
    tsmp_sync_pkt* pkt = (tsmp_sync_pkt*)malloc(sizeof(tsmp_sync_pkt));
    os_tsmp_header_generate(&(pkt->os_t_header), context->dev_info->dmac, context->dev_info->smac, TSMP_ETH_TYPE, 0x6,0x1);
    os_header_generate(CM_DISPATCH_PIT, &(pkt->os_header));

    struct pcf_payload* payload = gen_pcf_payload(context->cm_info->cur_sinfo->local_integration_cycle, context->cm_info->cur_sinfo->local_sync_membership, IN_TYPE);
    pkt->payload = *((pcf_pkt*)gen_pcf_pkt(context->dev_info->mac,context->dev_info->dmac,payload));

    os_pkt_send((u8*)pkt,PCF_SIZE,libnet_handle);
    //printf("cm send in\n");
    return 0;
}


u8* gen_pcf_pkt(const u8* dst_mac, const u8* src_mac, struct pcf_payload* payload)
{
    struct pcf_pkt* pkt = (struct pcf_pkt*)malloc(sizeof(struct pcf_pkt));

    memcpy(pkt->dmac, dst_mac, 6);
    memcpy(pkt->smac, src_mac, 6);

    pkt->ether_type = htons(ETHERNET_PCF_TYPE);
    pkt->integration_cycle = payload->integration_cycle;
    pkt->reserved1 = 0;
    pkt->reserved2 = 0;
    pkt->reserved3 = 0;
    pkt->membership_new = payload->membership_new;
    pkt->sync_priority = payload->sync_priority;
    pkt->sync_domain = payload->sync_domain;
    pkt->type = payload->type;
    //printf("---------pcf type  = %d\n",payload->type);
    pkt->transparent_clock = payload->transparent_clock;

    return (u8*)pkt;
}


pcf_payload* gen_pcf_payload(u32 integration_cycle, u32 membership_new, u8 type)
{
    struct pcf_payload* payload = (pcf_payload*)malloc(sizeof(pcf_payload));

    if (type != CS_TYPE && type != CA_TYPE && type != IN_TYPE) {
       perror("Wrong type of PCF");
       exit(-1);
    }

    payload->integration_cycle = htonl(integration_cycle);
    payload->membership_new = htonl(membership_new);
    payload->type = type;
    //printf("pcf type  = %d\n",payload->type);
    payload->sync_domain = 0;
    payload->sync_priority = 0;
    payload->transparent_clock = htonll(0);
    return payload;
}

int sm_tsmp_send(u8 pcf_type, libnet_t* libnet_handle,  tte_sync_context* context)
{
    // printf("=====%d\n",pcf_type);
    u32 pcf_integration_cycle = context->sm_info->cur_sinfo->local_integration_cycle;
    
    if (pcf_type == IN_TYPE) 
    {
        pcf_integration_cycle = (pcf_integration_cycle + 1) % gp_param.max_integration_cycle;
        //TODO:更新local_integration_cycle
        context->sm_info->cur_sinfo->local_integration_cycle = pcf_integration_cycle;
    }
    
    tsmp_sync_pkt* pkt = (tsmp_sync_pkt*)malloc(sizeof(tsmp_sync_pkt));
    os_tsmp_header_generate(&(pkt->os_t_header), context->dev_info->dmac, context->dev_info->smac, TSMP_ETH_TYPE, 0x6,0x1);
    os_header_generate(0, &(pkt->os_header));

    u32 pcf_membership = 1 << (context->device_id);
    struct pcf_payload* payload = gen_pcf_payload(pcf_integration_cycle, pcf_membership, pcf_type);
    
    struct pcf_pkt* p_pcf_pkt = (struct pcf_pkt*)gen_pcf_pkt(context->dev_info->mac, context->dev_info->dmac, payload);
    u64 static_delay = (context->sm_info->static_delay)<<16;
    p_pcf_pkt->transparent_clock = htonll(static_delay);
    
    pkt->payload = *p_pcf_pkt;

    os_pkt_send((u8*)pkt,PCF_SIZE,libnet_handle);
    return 0;
}

