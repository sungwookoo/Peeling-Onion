package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.field.controller.dto.*;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.domain.Storage;
import com.ssafy.peelingonion.field.service.FieldService;
import com.ssafy.peelingonion.field.service.exceptions.*;
import com.ssafy.peelingonion.onion.domain.Onion;

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

    private final FieldService fieldService;
    @Autowired
    public FieldController(FieldService fieldService){
        this.fieldService = fieldService;
    }

    @PostMapping("/{userId}")
    public ResponseEntity<FieldCreateResponse> createField(
            @RequestHeader("Authorization") String token,
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
            @RequestHeader("Authorization") String token,
            @PathVariable Long userId) {
        // **생략**auth check
        // **인증 후의 과정
        try {
            List<Field> fields = fieldService.readAllFields(userId);
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

    @GetMapping("/{userId}/{fieldId}")
    public ResponseEntity<List<OnionOutlineDto>> readFieldOnions(
            @RequestHeader("Authorization") String token,
            @PathVariable Long fieldId){
        // **생략**auth check
        // **인증 후의 과정
        try {
            // field id에 해당하는 양파id를 찾고 양파dto를 만들고 이들을 리스트로 넣어서 만든다.
            List<OnionOutlineDto> onionInfos = new ArrayList<>();
            // storages를 찾고
            List<Storage> storages = fieldService.findStorages(fieldId);
            // storages를 순회하면서 storage의 양파id를 찾고 양파 OnionDto를 만들어서 List에 추가하기
            for(Storage storage : storages){
                Onion fieldOnion = storage.getOnion();
                //*********************************************************************************************************//
                //******************                                                      *********************************//
                //****************                                                            ******************************//
                //***************                  ******************                          ****************************//
                //***************                 ********************                         *****************************//
                //****************               **********************                       *****************************//
                //*******************          *************************                     ******************************//
                //*********************      ********************************************* ********************************//
                //********************* *******         *******************           ****     ****************************//
                //********************* ************************************************* **** **************************//
                //********************* ***********    *********  ***********   ********* **** ***************************//
                //********************* ************************  ********************** *** ***************************//
                //********************** *********************  ************************ **********************************//
                //*********************** *******************       ******************** ***********************************//
                //*********************** ********************************************* ***********************************//
                //************************ *****************         ***************** ************************************//
                //************************** *************************************** **************************************//
                //*************************** ************************************ ****************************************//
                //********************************                                ******************************************//
                //*********************************************************************************************************//
                // fieldOnion의 userId값을 통해서 userName을 받아와주세요!:_)
                String userName = "zzangbae"; //***임의의 발신자값(더미데이터) ** 코드 진행 후 삭제해 주세요 **
                OnionOutlineDto onionOutlineDto = OnionOutlineDto.builder()
                        .id(fieldOnion.getId())
                        .onionName(fieldOnion.getName())
                        .imgSrc(fieldOnion.getImgSrc())
                        .recieveDate(fieldOnion.getSendDate())
                        .sender(userName)       //***이부분도 바껴야합니다.
                        .isSingle(fieldOnion.getIsSingle())
                        .build();
                onionInfos.add(onionOutlineDto);
            }
            return ResponseEntity.ok(onionInfos);
        } catch(FieldNotFoundException e){
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @PutMapping("/{userId}/{fieldId}")
    public ResponseEntity<FieldReadResponse> updateField(
            @RequestHeader("Authorization") String token,
            @RequestBody FieldUpdateRequest fieldUpdateRequest,
            @PathVariable Long fieldId){
        // **생략**auth check
        // **인증 후의 과정
        try {
            Field field = fieldService.updateField(fieldId, fieldUpdateRequest.getName());
            FieldReadResponse fieldReadResponse = FieldReadResponse.builder()
                    .id(field.getId())
                    .name(field.getName())
                    .createdAt((field.getCreatedAt()))
                    .build();
            return ResponseEntity.ok(fieldReadResponse);
        } catch(FieldNotUpdatedException e){
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }
    }

    @DeleteMapping("/{userId}/{fieldId}")
    public ResponseEntity<Boolean> deleteField(
            @RequestHeader("Authorization") String token,
            @PathVariable Long fieldId){
        // **생략**auth check
        // **인증 후의 과정
        try {
            fieldService.deleteField(fieldId);
            return ResponseEntity.ok().build();
        } catch(FieldNotDeletedException e){
            log.info(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }
    }
}
