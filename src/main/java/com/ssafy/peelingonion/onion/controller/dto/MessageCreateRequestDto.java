package com.ssafy.peelingonion.onion.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
// 메세지(양파 겹에서 음성메세지 뺀 것) 요청 정보 - 저장 눌렀을 때
public class MessageCreateRequestDto {
    // cf) 유저 ID는 토큰 값을 통해서 받을 예정
    // cf) 생성일은 저장 하는 순간 저장된다.
    // 1. 양파 ID
    public Long onion_id;
    // 2. 메세지 내용
    public String content;
    // 3. 긍정 비율
    public Double pos_rate;
    // 4. 부정 비율
    public Double neg_rate;
    // 5. 녹음 디바이스 S3주소
    public String file_src;
}
