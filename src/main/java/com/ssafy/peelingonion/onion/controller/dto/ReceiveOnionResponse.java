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
public class ReceiveOnionResponse {
    public Long id;
    public String name;
    public String img_src;
    public Instant receive_date;
    public String sender;
    public Boolean is_single;
    public Instant created_at;
    public Instant grow_due_date;
}
