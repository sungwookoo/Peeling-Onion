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
    public Double pos_rate;
    public Double neg_rate;
    public String file_src;
    public static MessageDetailResponse from(Long messageId, String userName, Message message) {
        return MessageDetailResponse.builder()
                .id(messageId)
                .sender(userName)
                .created_at(message.getCreatedAt())
                .pos_rate(message.getPosRate())
                .neg_rate(message.getNegRate())
                .file_src(message.getRecord().getFileSrc())
                .build();
    }
}
