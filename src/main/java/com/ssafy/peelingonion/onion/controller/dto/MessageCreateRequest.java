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
    public Long id;
    public String content;
    public Double pos_rate;
    public Double neg_rate;
    public String file_src;
}
