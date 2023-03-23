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
    public String imgSrc;
    public Instant receiveDate;
    public String sender;
    public Boolean isSingle;
    public Instant createdAt;
    public Instant growDueDate;
}
