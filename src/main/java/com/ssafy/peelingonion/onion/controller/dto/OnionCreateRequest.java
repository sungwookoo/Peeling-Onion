package com.ssafy.peelingonion.onion.controller.dto;

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
public class OnionCreateRequest {
    public String onionName;
    public String imgSrc;
    public String reciverNumber;
    public Instant growDueDate;
    public Boolean isSingle;
    // 모아보내기인 경우 같이 보낼 사람
    public List<Long> userIdList;
}
