package com.ssafy.peelingonion.user.service.exceptions;

public class Client4xxError extends RuntimeException {

	public Client4xxError() {
		super();
	}

	public Client4xxError(String message) {
		super(message);
	}
}

