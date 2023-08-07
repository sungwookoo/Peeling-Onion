package com.ssafy.peelingonion.common;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

@Component
public class ConstValues {
	public static String AUTH_SERVER;
	public static WebClient AUTH_SERVER_CLIENT;
	public static String USER_SERVER;
	public static WebClient USER_SERVER_CLIENT;
	public static String ALARM_SERVER;
	public static WebClient ALARM_SERVER_CLIENT;
	public static final String AUTH_URI = "/auth/validity/kakao";
	public static final Long UNAUTHORIZED_USER = -2L;
	public static final Long NON_MEMBER = -1L;
	public static final int ONION_DEAD = 1; // 양파가 상하는 경우
	public static final int ONION_RECEIVE = 2; // 양파를 받은 경우
	public static final int ONION_GROW_DONE = 3; // 양파가 성장완료한 경우
	public static final int ONION_ADD_SENDER = 4; // 양파 모아보내기에 보낸이에 추가된 경우

	@Value(value = "${authServer}")
	public void setAuthServer(String authServer) {
		this.AUTH_SERVER = authServer;
		AUTH_SERVER_CLIENT = WebClient.builder().baseUrl(AUTH_SERVER).build();
	}

	@Value(value = "${userServer}")
	public void setUserServer(String userServer) {
		this.USER_SERVER = userServer;
		USER_SERVER_CLIENT = WebClient.builder().baseUrl(USER_SERVER).build();
	}

	@Value(value = "${alarmServer}")
	public void setAlarmServer(String alarmServer) {
		this.ALARM_SERVER = alarmServer;
		ALARM_SERVER_CLIENT = WebClient.builder().baseUrl(ALARM_SERVER).build();
	}
}
