package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.field.service.FieldService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/v1/field")
public class FieldController {
    private final FieldService fieldService;

    @Autowired
    public FieldController(FieldService fieldService) {
        this.fieldService = fieldService;
    }

    // 밭 추가
//    @PostMapping("/{user_id}")
//
//    // 유저의 모든 필드를 가져오는 컨트롤러
//    @GetMapping("/{user_id}")
//    public ResponseEntity<FieldDtos> readFields()

    // 유저의 정보를 가져옴
//    @PostMapping("/{user_id}")
//    public ResponseEntity<Boolean> createField()

}
