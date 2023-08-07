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
    public Integer pos_rate;
    public Integer neg_rate;
    public Integer neu_rate;
    public String file_src;
}
