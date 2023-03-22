package com.ssafy.peelingonion.onion.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

import com.ssafy.peelingonion.onion.domain.Message;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageSmallDto {
    private Long id;
    // 유저 아이디의 유저 닉네임을 찾아서 Dto에 집어넣는다.
    private String nickname;
    private Instant createdAt;
    private String content;
    private Double posRate;
    private Double negRate;
    // recordedVoice로부터 fileSrc를 찾는다.
    private String fileSrc;

    public static MessageSmallDto makeSmallMDto(Message message, String nickname) {
        return MessageSmallDto.builder()
                .id(message.getId())
                .nickname(nickname)
                .createdAt(message.getCreatedAt())
                .content(message.getContent())
                .posRate(message.getPosRate())
                .negRate(message.getNegRate())
                .fileSrc(message.getRecord().getFileSrc())
                .build();
    }
}
