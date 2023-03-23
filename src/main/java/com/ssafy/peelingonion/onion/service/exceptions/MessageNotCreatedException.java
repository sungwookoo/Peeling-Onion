package com.ssafy.peelingonion.onion.service.exceptions;

public class MessageNotCreatedException extends RuntimeException {
    public MessageNotCreatedException() {
        super();
    }
    public MessageNotCreatedException(String message) {
        super(message);
    }
}
