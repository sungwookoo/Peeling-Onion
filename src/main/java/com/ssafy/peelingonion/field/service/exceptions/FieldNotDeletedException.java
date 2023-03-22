package com.ssafy.peelingonion.field.service.exceptions;

public class FieldNotDeletedException extends RuntimeException {
    public FieldNotDeletedException(){
        super();
    }
    public FieldNotDeletedException(String message){
        super(message);
    }
}
