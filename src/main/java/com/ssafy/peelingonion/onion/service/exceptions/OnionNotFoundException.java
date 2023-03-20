package com.ssafy.peelingonion.onion.service.exceptions;

public class OnionNotFoundException extends RuntimeException{
    public OnionNotFoundException() {
        super();
    }

    public OnionNotFoundException(String message) {
        super(message);
    }
}
