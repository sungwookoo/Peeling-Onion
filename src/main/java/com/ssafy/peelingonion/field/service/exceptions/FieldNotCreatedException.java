package com.ssafy.peelingonion.field.service.exceptions;

public class FieldNotCreatedException extends RuntimeException {
    public FieldNotCreatedException() {
        super();
    }
    public FieldNotCreatedException(String message) {
        super(message);
    }
}
