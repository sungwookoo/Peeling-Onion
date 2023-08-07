package com.ssafy.peelingonion.user.controller.dto;

import com.ssafy.peelingonion.user.domain.User;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserResponseDto {
	public final long id;
	public final String createDate;
	public final String mobile_number;
	public final String nickname;

	public static UserResponseDto from(User u) {
		return UserResponseDto.builder()
			.id(u.getId())
			.createDate(u.getCreatedAt().toString())
			.mobile_number(u.getMobileNumber())
			.nickname(u.getNickname())
			.build();
	}
}
