package com.ssafy.peelingonion.field.controller.dto;

import java.time.Instant;

public class OnionOutlineDto {
    public Long id;
    public String onionName;
    public String imgSrc;
    public Instant recieveDate; // 받은 날짜
    public Boolean sender; // 대표 발신자
    public Boolean isSingle; // True : 혼자보내는 것, False : 모아보내는 것
}
