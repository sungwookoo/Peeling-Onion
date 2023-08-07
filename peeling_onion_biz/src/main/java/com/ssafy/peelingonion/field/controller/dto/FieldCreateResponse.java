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
public class FieldCreateResponse {
	public Long id;
	public String name;
	public Instant created_at;

	public static FieldCreateResponse from(Field field) {
		return FieldCreateResponse.builder()
			.id(field.getId())
			.name(field.getName())
			.created_at(field.getCreatedAt())
			.build();
	}
}
