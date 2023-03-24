package com.ssafy.peelingonion.onion.service.exceptions;

public class DeleteOnionFailException extends RuntimeException {
    public DeleteOnionFailException() {
        super();
    }
    public DeleteOnionFailException(String message) {
        super(message);
    }
}
