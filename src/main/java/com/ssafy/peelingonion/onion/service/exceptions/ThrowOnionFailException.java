package com.ssafy.peelingonion.onion.service.exceptions;

public class ThrowOnionFailException extends RuntimeException {
    public ThrowOnionFailException() {
        super();
    }
    public ThrowOnionFailException(String message) {
        super(message);
    }
}
