package com.ssafy.peelingonion.user.service.exceptions;

public class Client5xxError extends RuntimeException {

	public Client5xxError() {
		super();
	}

	public Client5xxError(String message) {
		super(message);
	}
}

