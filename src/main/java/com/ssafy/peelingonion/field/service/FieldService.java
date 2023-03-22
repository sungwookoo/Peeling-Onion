package com.ssafy.peelingonion.field.service;

import com.ssafy.peelingonion.field.controller.dto.FieldCreateRequest;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.domain.FieldRepository;
import com.ssafy.peelingonion.field.domain.MyField;
import com.ssafy.peelingonion.field.domain.MyFieldRepository;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@Service
public class FieldService {
    private final FieldService fieldService;
    private final FieldRepository fieldRepository;
    private final MyFieldRepository myFieldRepository;

    public FieldService(FieldService fieldService,
                        FieldRepository fieldRepository,
                        MyFieldRepository myFieldRepository) {
        this.fieldService = fieldService;
        this.fieldRepository = fieldRepository;
        this.myFieldRepository = myFieldRepository;
    }

    public Field createField(FieldCreateRequest fieldCreateReuqest, Long userId) {
        // Field 객체 생성 후, 저장
        Field field = Field.builder()
                .name(fieldCreateReuqest.getName())
                .isDisabled(Boolean.FALSE)
                .createdAt(Instant.now())
                .build();
        fieldRepository.save(field);
        // myField 객체 생성 후, 저장
        MyField myField = MyField.builder()
                .userId(userId)
                .field(field)
                .build();
        myFieldRepository.save(myField);
        return field;
    }

    public List<Field> readAllFields(Long userId) {
        // userId로 MyField 리스트를 찾기
        List<MyField> myFields = myFieldRepository.findAllByUserId(userId);
        List<Field> fields = new ArrayList<>();
        // 해당 리스트로부터 Field 리스트를 찾기
        for(MyField myField : myFields){
            Field field = fieldRepository.findById(myField.getField().getId()).orElseThrow();
            // 해당 필드 disalbed 체크하기(false면 리스트에 넣기)
            if(field.getIsDisabled() == Boolean.FALSE){
                fields.add(field);
            }
        }
        return fields;
    }
}
