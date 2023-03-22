package com.ssafy.peelingonion.user.controller.dto;

import java.time.Instant;

import com.ssafy.peelingonion.user.domain.User;

import lombok.Data;

@Data
public class UserRequestDto {
	private final String nickname;
	private final String mobile_number;
	private final String img_src;
	private final String kakaoId;
	public static User to(UserRequestDto userRequestDto){
		return User.builder()
			.kakaoId(userRequestDto.kakaoId)
			.nickname(userRequestDto.nickname)
			.imgSrc(userRequestDto.img_src)
			.createdAt(Instant.now())
			.activate(true)
			.mobileNumber(userRequestDto.mobile_number)
			.build();
	}
}
