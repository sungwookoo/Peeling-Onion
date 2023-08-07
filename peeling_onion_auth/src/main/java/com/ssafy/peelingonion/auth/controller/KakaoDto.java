package com.ssafy.peelingonion.auth.controller;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KakaoDto {
	public Long id;
	public Integer expires_in;
	public Integer app_id;
	public Integer expiresInMillis;
	public Integer appId;
}
