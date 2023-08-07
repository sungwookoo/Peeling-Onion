package com.ssafy.peelingonion.service.exceptions;

public class Client4xxException extends RuntimeException {

	public Client4xxException() {
		super();
	}

	public Client4xxException(String message) {
		super(message);
	}
}

