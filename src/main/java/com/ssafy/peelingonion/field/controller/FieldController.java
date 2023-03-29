package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
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
@RequestMapping("/field")
public class FieldController {

    private final FieldService fieldService;
    private final AuthorizeService authorizeService;
    @Autowired
    public FieldController(FieldService fieldService, AuthorizeService authorizeService){
        this.fieldService = fieldService;
        this.authorizeService = authorizeService;
    }

    /**
     * 나의 밭에서 새로운 밭을 생성하는 API
     * @param token 로그인 유저의 토큰
     * @param fieldCreateRequest 밭을 생성하기 위해서 필요한 정보
     * @return 밭 생성 후 생성된 밭의 정보를 반환
     */
    @PostMapping("")
    public ResponseEntity<FieldCreateResponse> createField(
            @RequestHeader("Authorization") String token,
            @RequestBody FieldCreateRequest fieldCreateRequest) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)) {
            try {
                Field field = fieldService.createField(fieldCreateRequest, userId);
                return ResponseEntity.ok(FieldCreateResponse.from(field));
            } catch(FieldNotCreatedException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 나의 모든 밭 정보를 가져오는 API
     * @param token 로그인 유저의 토큰
     * @return 밭 UI를 구성하는데에 필요한 모든 정보를 반환
     */
    @GetMapping("")
    public ResponseEntity<List<FieldReadResponse>> readAllFields(
            @RequestHeader("Authorization") String token) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                List<Field> fields = fieldService.readAllFields(userId);
                List<FieldReadResponse> fieldReadResponses = new ArrayList<>();
                for(Field field : fields){
                    FieldReadResponse fieldReadResponse = FieldReadResponse.from(field);
                    fieldReadResponses.add(fieldReadResponse);
                }
                return ResponseEntity.ok(fieldReadResponses);
            } catch(FieldAllNotFoundException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    /**
     * 클릭한 밭의 양파들의 개략 정보들을 주는 API
     * @param token 로그인 유저의 토큰
     * @param fieldId 클릭한 밭의 id
     * @return 클릭한 밭에 있는 양파들의 정보
     */
    @GetMapping("/{fieldId}")
    public ResponseEntity<List<OnionOutlineDto>> readFieldOnions(
            @RequestHeader("Authorization") String token,
            @PathVariable Long fieldId){
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)) {
            try {
                List<OnionOutlineDto> onionInfos = new ArrayList<>();
                List<Storage> storages = fieldService.findStorages(fieldId);
                for(Storage storage : storages){
                    Onion fieldOnion = storage.getOnion();
                    String userName = fieldService.getNameByUserId(userId);
                    onionInfos.add(OnionOutlineDto.from(fieldOnion, userName));
                }
                return ResponseEntity.ok(onionInfos);
            } catch(FieldNotFoundException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 밭의 이름을 바꾸는 API
     * @param token 로그인 유저의 토큰
     * @param fieldUpdateRequest 밭의 이름을 변경하기 위해서 필요한 요청 정보
     * @param fieldId 이름을 변경할 밭의 id
     * @return 변경된 밭의 정보를 반환한다.
     */
    @PutMapping("/{fieldId}")
    public ResponseEntity<FieldReadResponse> updateField(
            @RequestHeader("Authorization") String token,
            @RequestBody FieldUpdateRequest fieldUpdateRequest,
            @PathVariable Long fieldId){
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                Field field = fieldService.updateField(fieldId, fieldUpdateRequest.getName());
                return ResponseEntity.ok(FieldReadResponse.from(field));
            } catch(FieldNotUpdatedException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 나의 밭 중에서 특정 밭을 삭제
     * 밭에 있는 모든 양파의 정보도 삭제된다.(isDisabled = Boolean.TRUE)
     * @param token 로그인 유저의 토큰
     * @param fieldId 삭제할 밭의 id
     * @return 삭제 성공 여부를 반환
     */
    @DeleteMapping("/{fieldId}")
    public ResponseEntity<Boolean> deleteField(
            @RequestHeader("Authorization") String token,
            @PathVariable Long fieldId){
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)) {
            try {
                fieldService.deleteField(fieldId);
                return ResponseEntity.ok().build();
            } catch(FieldNotDeletedException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

}
