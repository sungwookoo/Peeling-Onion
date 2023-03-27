package com.ssafy.peelingonion.onion.controller.dto;

import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.ReceiveOnion;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OnionDetailResponse {
    public Long id;
    public String name;
    public String img_src;
    public String sender;
    public Instant created_at;
    public Instant send_date;
    public Instant grow_due_date;
    public Boolean is_single;
    public Boolean is_bookmarked;
    public List<Long> message_id_list;
    public static OnionDetailResponse from(Onion o, ReceiveOnion r, String userName, List<Long> messageIdList){
        return OnionDetailResponse.builder()
                .id(o.getId())
                .name(o.getName())
                .img_src(o.getImgSrc())
                .sender(userName)
                .created_at(o.getCreatedAt())
                .send_date(o.getSendDate())
                .grow_due_date(o.getGrowDueDate())
                .is_single(o.getIsSingle())
                .is_bookmarked(r.getIsBookmarked())
                .message_id_list(messageIdList)
                .build();
    }
}
