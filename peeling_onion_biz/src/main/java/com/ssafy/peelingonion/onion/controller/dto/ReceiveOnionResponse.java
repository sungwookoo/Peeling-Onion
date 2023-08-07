package com.ssafy.peelingonion.onion.controller.dto;

import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.ReceiveOnion;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReceiveOnionResponse {
    public Long id;
    public String name;
    public String img_src;
    public Instant receive_date;
    public String sender;
    public Boolean is_single;
    public Instant created_at;
    public Instant grow_due_date;
    public static ReceiveOnionResponse from(ReceiveOnion receiveOnion, String senderName){
        Onion o = receiveOnion.getOnion();
        return ReceiveOnionResponse.builder()
                .id(o.getId())
                .name(o.getName())
                .img_src(o.getImgSrc())
                .receive_date(o.getSendDate())
                .sender(senderName)
                .is_single(o.getIsSingle())
                .created_at(o.getCreatedAt())
                .grow_due_date(o.getGrowDueDate())
                .build();
    }
}
