package com.ssafy.peelingonion.common;

import org.springframework.web.reactive.function.client.WebClient;

public class ConstValues {
	public static final String AUTH_SERVER = "https://test.auth.ssafy.shop";
	public static final WebClient AUTH_SERVER_CLIENT = WebClient.builder().baseUrl(AUTH_SERVER).build();
	public static final String AUTH_URI = "/auth/validity/kakao";
	public static final Long UNAUTHORIZED_USER = -2L;
	public static final Long NON_MEMBER = -1L;
}
