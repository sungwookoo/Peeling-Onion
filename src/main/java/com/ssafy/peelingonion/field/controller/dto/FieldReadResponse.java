package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

import com.ssafy.peelingonion.field.domain.Field;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
// Field하나의 정보, 이 안에 양파정보(개요)도 담겨져있다.
public class FieldReadResponse {
	public Long id;
	public String name;
	public Instant createdAt;
	public List<OnionOutlineDto> onionInfos;

	public static FieldReadResponse from(Field field) {
		return FieldReadResponse.builder()
			.id(field.getId())
			.name(field.getName())
			.createdAt((field.getCreatedAt()))
			.build();
	}
}
