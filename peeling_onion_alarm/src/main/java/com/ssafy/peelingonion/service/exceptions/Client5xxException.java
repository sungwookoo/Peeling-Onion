package com.ssafy.peelingonion.service.exceptions;

public class Client5xxException extends RuntimeException {

	public Client5xxException() {
		super();
	}

	public Client5xxException(String message) {
		super(message);
	}
}

