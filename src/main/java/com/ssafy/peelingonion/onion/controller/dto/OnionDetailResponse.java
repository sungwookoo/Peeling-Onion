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
    public String imgSrc;
    public String sender;
    public Instant createdAt;
    public Instant sendDate;
    public Instant growDueDate;
    public Boolean isSingle;
    public Boolean isBookmarked;
    public List<Long> messageIdList;
}
