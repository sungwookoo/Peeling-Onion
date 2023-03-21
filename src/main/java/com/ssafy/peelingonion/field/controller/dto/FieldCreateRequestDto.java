package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FieldCreateRequestDto {
    // cf) 유저 ID는 토큰 값을 통해서 받을 예정
    // cf) 생성일은 저장하는 순간 저장된다.
    public String name;
}
