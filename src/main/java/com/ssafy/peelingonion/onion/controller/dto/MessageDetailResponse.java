package com.ssafy.peelingonion.onion.controller.dto;

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
    public Instant createdAt;
    public String content;
    public Double posRate;
    public Double negRate;
    public String fileSrc;
}
