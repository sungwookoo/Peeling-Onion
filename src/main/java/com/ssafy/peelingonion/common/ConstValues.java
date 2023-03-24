package com.ssafy.peelingonion.common;

import org.springframework.web.reactive.function.client.WebClient;

public class ConstValues {
	public static final String AUTH_SERVER = "https://auth.ssafy.shop";
	public static final WebClient AUTH_SERVER_CLIENT = WebClient.builder().baseUrl(AUTH_SERVER).build();
	public static final String USER_SERVER = "https://user.ssafy.shop";
	public static final WebClient USER_SERVER_CLIENT = WebClient.builder().baseUrl(USER_SERVER).build();
	public static final String AUTH_URI = "/auth/validity/kakao";
	public static final Long UNAUTHORIZED_USER = -2L;
	public static final Long NON_MEMBER = -1L;

	private ConstValues() {
	}
}
