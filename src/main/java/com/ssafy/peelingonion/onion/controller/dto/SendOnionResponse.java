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
    public String img_src;
    public Instant created_at;
    public Instant lastest_modified;
    public Instant grow_due_date;
    public Boolean is_single;
    public String receiver_number;
    public boolean is_dead;
    public boolean is_time2go;
    public static SendOnionResponse from(SendOnion s, boolean isDead, boolean isTime2Go){
        Onion o = s.getOnion();
        return SendOnionResponse.builder()
                .id(o.getId())
                .name(o.getName())
                .img_src(o.getImgSrc())
                .created_at(o.getCreatedAt())
                .grow_due_date(o.getGrowDueDate())
                .is_single(o.getIsSingle())
                .receiver_number(s.getReceiverNumber())
                .is_dead(isDead)
                .is_time2go(isTime2Go)
                .build();
    }
}
