package com.ssafy.peelingonion.onion.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageCreateRequest {
    public Long onionId;
    public String content;
    public Double posRate;
    public Double negRate;
    public String fileSrc; // 녹음 S3주소
}
