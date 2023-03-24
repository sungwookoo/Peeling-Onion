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
    public String name;
    public String img_src;
    public String receiver_number;
    public Instant grow_due_date;
    public Boolean is_single;
    // 모아보내기인 경우 같이 보낼 사람
    public List<Long> user_id_list;
}
