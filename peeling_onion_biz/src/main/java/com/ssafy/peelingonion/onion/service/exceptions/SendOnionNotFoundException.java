package com.ssafy.peelingonion.onion.service.exceptions;

public class SendOnionNotFoundException extends RuntimeException {
    public SendOnionNotFoundException() {
        super();
    }
    public SendOnionNotFoundException(String message){
        super(message);
    }
}
