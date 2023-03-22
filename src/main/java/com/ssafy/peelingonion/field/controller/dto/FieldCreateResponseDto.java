package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

import com.ssafy.peelingonion.field.domain.Field;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FieldCreateResponseDto {

    public Long id;
    public String name;
    public Instant createdAt;
    public Boolean isDisabled;

    public static FieldCreateResponseDto makeFieldCreateDto(Field field) {
        return FieldCreateResponseDto.builder()
                .id(field.getId())
                .name(field.getName())
                .createdAt(field.getCreatedAt())
                .isDisabled(field.getIsDisabled())
                .build();
    }
}
