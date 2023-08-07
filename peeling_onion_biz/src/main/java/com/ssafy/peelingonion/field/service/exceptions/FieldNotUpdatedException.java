package com.ssafy.peelingonion.field.service.exceptions;

public class FieldNotUpdatedException extends RuntimeException{
    public FieldNotUpdatedException(){
        super();
    }
    public FieldNotUpdatedException(String message){
        super(message);
    }
}
