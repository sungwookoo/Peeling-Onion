package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OnionOutlineDto {
    public Long id;
    public String onionName;
    public String imgSrc;
    public Instant receiveDate; // 받은 날짜
    public String sender; // 대표 발신자
    public Boolean isSingle; // True : 혼자보내는 것, False : 모아보내는 것
}
