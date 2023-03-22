package com.ssafy.peelingonion.user.controller.dto;

import com.ssafy.peelingonion.user.domain.User;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SearchUserResponseDto {
	public final Long id;
	public final String nickname;
	public final String mobileNumber;

	public static SearchUserResponseDto from(User user){
		return SearchUserResponseDto.builder()
			.id(user.getId())
			.nickname(user.getNickname())
			.mobileNumber(user.getMobileNumber())
			.build();
	}
}
