package com.ssafy.peelingonion.user.controller.dto;

import java.time.Instant;

import com.ssafy.peelingonion.user.domain.User;

import lombok.Data;

@Data
public class UserRequestDto {
	private final String nickname;
	private final String mobile_number;
	private final String img_src;
	private final Long kakaoId;

	/**
	 * ID값이 누락되어 있다.
	 * ID값을 입력하고 싶을땐 to(UserRequestDto userRequestDto, Long userId)함수를 이용
	 * @param userRequestDto
	 * @return
	 */
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
	public static User to(UserRequestDto userRequestDto, Long userId){
		return User.builder()
			.id(userId)
			.kakaoId(userRequestDto.kakaoId)
			.nickname(userRequestDto.nickname)
			.imgSrc(userRequestDto.img_src)
			.createdAt(Instant.now())
			.activate(true)
			.mobileNumber(userRequestDto.mobile_number)
			.build();
	}
}
