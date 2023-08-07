package com.ssafy.peelingonion.onion.controller.dto;

import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.SendOnion;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SendOnionResponse {
    public Long id;
    public String name;
    public String onion_maker;
    public boolean is_onion_maker;
    public String img_src;
    public Instant created_at;
    public Instant lastest_modified;
    public Instant grow_due_date;
    public Boolean is_single;
    public String receiver_number;
    public boolean is_dead;
    public boolean is_time2go;
    public boolean is_watered;
    public static SendOnionResponse from(SendOnion s, boolean is_onion_maker, String onion_maker, boolean isDead, boolean isTime2Go, boolean isWatered){
        Onion o = s.getOnion();
        return SendOnionResponse.builder()
                .id(o.getId())
                .name(o.getName())
                .onion_maker(onion_maker)
                .is_onion_maker(is_onion_maker)
                .img_src(o.getImgSrc())
                .created_at(o.getCreatedAt())
                .lastest_modified(o.getLatestModify())
                .grow_due_date(o.getGrowDueDate())
                .is_single(o.getIsSingle())
                .receiver_number(s.getReceiverNumber())
                .is_dead(isDead)
                .is_time2go(isTime2Go)
                .is_watered(isWatered)
                .build();
    }
}
