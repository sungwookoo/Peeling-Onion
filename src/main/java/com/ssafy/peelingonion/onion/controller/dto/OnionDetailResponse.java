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
public class OnionDetailResponse {
    public Long id;
    public String name;
    public String img_src;
    public String sender;
    public Instant created_at;
    public Instant send_date;
    public Instant grow_due_date;
    public Boolean is_single;
    public Boolean is_bookmarked;
    public List<Long> message_id_list;
}
