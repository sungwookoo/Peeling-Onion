package com.ssafy.peelingonion.auth.service.exceptions;

public class KakaoError extends RuntimeException {

	public KakaoError() {
		super();
	}

	public KakaoError(String message) {
		super(message);
	}
}

