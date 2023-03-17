package com.ssafy.peelingonion.user.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {
	public long id;
	public String date;
	public String mobile_number;
	public String nickname;
}

