package com.ssafy.peelingonion.onion.service.exceptions;

public class ReceiveOnionNotFoundException extends RuntimeException {
    public ReceiveOnionNotFoundException() {
        super();
    }
    public ReceiveOnionNotFoundException(String message) {
        super(message);
    }
}
