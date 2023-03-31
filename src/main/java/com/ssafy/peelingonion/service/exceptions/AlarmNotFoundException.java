package com.ssafy.peelingonion.service.exceptions;

public class AlarmNotFoundException extends RuntimeException {

	public AlarmNotFoundException() {
		super();
	}

	public AlarmNotFoundException(String message) {
		super(message);
	}
}

