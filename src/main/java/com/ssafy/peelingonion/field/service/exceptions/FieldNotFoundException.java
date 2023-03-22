package com.ssafy.peelingonion.field.service.exceptions;

public class FieldNotFoundException extends RuntimeException{
    public FieldNotFoundException(){
        super();
    }
    public FieldNotFoundException(String message){
        super(message);
    }
}
