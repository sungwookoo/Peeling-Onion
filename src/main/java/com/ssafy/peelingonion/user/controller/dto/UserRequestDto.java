package com.ssafy.peelingonion.user.controller.dto;

import lombok.Data;

@Data
public class UserRequestDto {
	private final String nickname;
	private final String mobile_number;
	private final String img_src;
}
