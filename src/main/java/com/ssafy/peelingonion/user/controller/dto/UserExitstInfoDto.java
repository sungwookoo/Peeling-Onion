package com.ssafy.peelingonion.user.controller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserExitstInfoDto {
	private final Long user_id;

	public static UserExitstInfoDto from(Long id) {
		return UserExitstInfoDto.builder()
			.user_id(id)
			.build();
	}
}
