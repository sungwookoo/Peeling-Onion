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
    public String imgSrc;
    public Instant createdAt;
    public Instant lastestModified;
    public Instant growDueDate;
    public Boolean isSingle;
    public String receiverNumber;
}
