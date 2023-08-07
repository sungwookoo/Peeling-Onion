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
public class FieldReadResponse {
	public Long id;
	public String name;
	public Instant created_at;
//	public List<OnionOutlineDto> onion_infos;

	public static FieldReadResponse from(Field field) {
		return FieldReadResponse.builder()
			.id(field.getId())
			.name(field.getName())
			.created_at((field.getCreatedAt()))
			.build();
	}
}
