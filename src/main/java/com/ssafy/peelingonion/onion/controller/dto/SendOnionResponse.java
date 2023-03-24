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
public class SendOnionResponse {
    public Long id;
    public String name;
    public String img_src;
    public Instant created_at;
    public Instant lastest_modified;
    public Instant grow_due_date;
    public Boolean is_single;
    public String receiver_number;
}
