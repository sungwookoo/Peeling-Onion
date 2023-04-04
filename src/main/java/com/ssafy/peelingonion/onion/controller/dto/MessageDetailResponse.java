package com.ssafy.peelingonion.onion.controller.dto;

import com.ssafy.peelingonion.onion.domain.Message;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageDetailResponse {
    public Long id;
    public String sender;
    public Instant created_at;
    public String content;
    public Integer pos_rate;
    public Integer neg_rate;
    public Integer neu_rate;
    public String file_src;
    public static MessageDetailResponse from(Long messageId, String messageSender, Message message) {
        return MessageDetailResponse.builder()
                .id(messageId)
                .sender(messageSender)
                .content(message.getContent())
                .created_at(message.getCreatedAt())
                .pos_rate(message.getPosRate())
                .neg_rate(message.getNegRate())
                .neu_rate(message.getNeuRate())
                .file_src(message.getRecord().getFileSrc())
                .build();
    }
}
