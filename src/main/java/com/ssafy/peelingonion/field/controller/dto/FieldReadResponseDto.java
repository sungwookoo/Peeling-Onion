package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
// 유저의 필드 정보를 전달한다.
// 이 때, 필드에 들어있는 양파의 요약정보를 보낸다.
// 요약 정보 : 양파 id, 양파 이름, 양파 이미지, 생성일, 수정일, 최종성장일
// 만약 삭제된 양파라면, 해당 양파는 가지 않도록 한다.
public class FieldReadResponseDto {
    // 밭 id
    public Long id;
    // 밭 이름
    public String name;
    // 밭 생성일
    public Instant createdAt;
    // 밭에 저장된 양파 정보들
    public List<OnionsInFieldDto> onions;
}
