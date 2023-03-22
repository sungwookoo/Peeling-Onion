package com.ssafy.peelingonion.field.service.exceptions;

public class FieldAllNotFoundException extends RuntimeException{
    public FieldAllNotFoundException(){
        super();
    }
    public FieldAllNotFoundException(String message){
        super(message);
    }
}
