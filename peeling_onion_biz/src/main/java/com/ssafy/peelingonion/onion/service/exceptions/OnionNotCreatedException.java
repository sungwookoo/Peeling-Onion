package com.ssafy.peelingonion.onion.service.exceptions;

public class OnionNotCreatedException extends RuntimeException {
    public OnionNotCreatedException() {
        super();
    }
    public OnionNotCreatedException(String message) {
        super(message);
    }
}
