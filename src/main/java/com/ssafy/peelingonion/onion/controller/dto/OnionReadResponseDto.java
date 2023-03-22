package com.ssafy.peelingonion.onion.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.Set;

import com.ssafy.peelingonion.onion.domain.Onion;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
// 양파 읽을 때 보내줄 정보
// 양파를 읽을 경우
// 택배함 or 받은 양파 밭에서 확인하는 경우
public class OnionReadResponseDto {
    // 양파 id
    public Long id;
    // 양파 이름
    public String onionName;
    // 수신자 정보(번호)
    public String mobileNumber;
    // 양파 종류(이미지)
    public String imgSrc;
    // 양파 생성일자(from yyyy-mm-dd부터)
    public Instant createdAt;
    // 양파 최종 성장일(to yyyy-mm-dd까지 키우셨어요!)
    public Instant growDueDate;
    // 양파의 메세지파일
    public Set<MessageSmallDto> messages;

    // need check
    public static OnionReadResponseDto makeOnionReadDto(Onion onion, Set<MessageSmallDto> messageSmallDtos){
        return OnionReadResponseDto.builder()
                .id(onion.getId())
                .onionName(onion.getOnionName())
                //.mobileNumber(onion.getMobileNumber())
                .imgSrc(onion.getImgSrc())
                .createdAt(onion.getCreatedAt())
                .growDueDate(onion.getGrowDueDate())
                .messages(messageSmallDtos)
                .build();
    }
}
