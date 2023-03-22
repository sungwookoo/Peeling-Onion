package com.ssafy.peelingonion.auth.controller;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class KakaoDto {
	public Long id;
	public Integer expires_in;
	public Integer app_id;
}
