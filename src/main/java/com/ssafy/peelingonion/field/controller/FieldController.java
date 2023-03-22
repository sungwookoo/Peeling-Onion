package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.field.controller.dto.FieldCreateRequest;
import com.ssafy.peelingonion.field.controller.dto.FieldCreateResponse;
import com.ssafy.peelingonion.field.controller.dto.FieldReadResponse;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.service.FieldService;
import com.ssafy.peelingonion.field.service.exceptions.FieldAllNotFoundException;
import com.ssafy.peelingonion.field.service.exceptions.FieldNotCreatedException;
import com.ssafy.peelingonion.onion.domain.OnionRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("v1/onion/field")
public class FieldController {
    private final OnionRepository onionRepository;
    private final FieldService fieldService;
    @Autowired
    public FieldController(FieldService fieldService,
                           OnionRepository onionRepository){
        this.fieldService = fieldService;
        this.onionRepository = onionRepository;
    }

    @PostMapping("/{userId}")
    public ResponseEntity<FieldCreateResponse> createField(
            @RequestBody FieldCreateRequest fieldCreateRequest,
            @PathVariable Long userId) {
        // **생략**auth check
        // **인증 후의 과정
        try {
            Field field = fieldService.createField(fieldCreateRequest, userId);
            FieldCreateResponse fieldCreateResponse = FieldCreateResponse.builder()
                    .id(field.getId())
                    .name(field.getName())
                    .createdAt(field.getCreatedAt())
                    .build();
            return ResponseEntity.ok(fieldCreateResponse);
        } catch(FieldNotCreatedException e){
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
        }
    }

    @GetMapping("/{userId}")
    public ResponseEntity<List<FieldReadResponse>> readAllFields(
            @PathVariable Long userId) {
        // **생략**auth check
        // **인증 후의 과정
        try {
            // 사용자가 가진 field들을 찾는다.
            List<Field> fields = fieldService.readAllFields(userId);
            // fields로부터 response를 만들자
            List<FieldReadResponse> fieldReadResponses = new ArrayList<>();
            for(Field field : fields){
                FieldReadResponse fieldReadResponse = FieldReadResponse.builder()
                        .id(field.getId())
                        .name(field.getName())
                        .createdAt(field.getCreatedAt())
                        .build();
                fieldReadResponses.add(fieldReadResponse);
            }
            return ResponseEntity.ok(fieldReadResponses);
        } catch(FieldAllNotFoundException e){
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

//    @GetMapping("/{userId}/{fieldId}")
}
