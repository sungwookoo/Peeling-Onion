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
    public Instant created_at;
    public String content;
    public Double pos_rate;
    public Double neg_rate;
    public String file_src;
}
