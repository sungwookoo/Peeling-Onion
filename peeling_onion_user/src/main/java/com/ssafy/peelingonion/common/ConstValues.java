package com.ssafy.peelingonion.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
public class ConstValues {
	public static String AUTH_SERVER;
	public static WebClient AUTH_SERVER_CLIENT;
	public static String BIZ_SERVER;
	public static WebClient BIZ_SERVER_CLIENT;
	public static final String AUTH_URI = "/auth/validity/kakao";
	public static final String CREATE_FILED_URI = "/field";
	public static final Long UNAUTHORIZED_USER = -2L;
	public static final Long NON_MEMBER = -1L;

	@Value(value = "${authServer}")
	public void setAuthServer(String authServer) {
		this.AUTH_SERVER = authServer;
		AUTH_SERVER_CLIENT = WebClient.builder().baseUrl(AUTH_SERVER).build();
	}
	@Value(value = "${bizServer}")
	public void setBizServer(String bizServer) {
		this.BIZ_SERVER = bizServer;
		BIZ_SERVER_CLIENT = WebClient.builder().baseUrl(BIZ_SERVER).build();
	}


}
