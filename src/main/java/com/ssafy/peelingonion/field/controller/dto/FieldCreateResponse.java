package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FieldCreateResponse {
    public Long id;
    public String name;
    public Instant createdAt;
}
