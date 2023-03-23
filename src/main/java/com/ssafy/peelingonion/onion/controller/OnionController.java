package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
import com.ssafy.peelingonion.onion.controller.dto.SendOnionResponse;
import com.ssafy.peelingonion.onion.domain.SendOnion;
import com.ssafy.peelingonion.onion.service.OnionService;
import com.ssafy.peelingonion.onion.service.exceptions.OnionNotCreatedException;
import com.ssafy.peelingonion.onion.service.exceptions.SendOnionNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("v1/onion")
public class OnionController {

    private final OnionService onionService;
    private final AuthorizeService authorizeService;

    @Autowired
    public OnionController(OnionService onionService, AuthorizeService authorizeService) {
        this.onionService = onionService;
        this.authorizeService = authorizeService;
    }

    @PostMapping("")
    public ResponseEntity<Boolean> createOnion(
            @RequestHeader("Authorization") String token,
            @RequestBody OnionCreateRequest onionCreateRequest) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.createOnion(onionCreateRequest, userId);
                return ResponseEntity.status(HttpStatus.CREATED).build();
            } catch (OnionNotCreatedException e) {
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    /**
     * 내가 키우고 있는 양파를 보여준다.
     * @param token
     * 전송 여부, 삭제 여부를 판단하여 전송하지 않았고, 삭제되지 않는 양파들의 리스트를 보내준다.
     * @return 키우고 있는 양파 리스트를 보여준다.
     */
    @GetMapping("/growing")
    public ResponseEntity<List<SendOnionResponse>> readSendOnions(
            @RequestHeader("Authorization") String token) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                List<SendOnion> sendOnions = onionService.findSendOnions(userId);
                List<SendOnionResponse> sendOnionResponses = new ArrayList<>();
                for(SendOnion sendOnion : sendOnions){
                    if(sendOnion.getOnion().getIsDisabled() != Boolean.FALSE) {
                        SendOnionResponse sendOnionResponse = SendOnionResponse.builder()
                                .id(sendOnion.getOnion().getId())
                                .name(sendOnion.getOnion().getName())
                                .imgSrc(sendOnion.getOnion().getImgSrc())
                                .createdAt(sendOnion.getOnion().getCreatedAt())
                                .lastestModified(sendOnion.getOnion().getLatestModify())
                                .growDueDate(sendOnion.getOnion().getGrowDueDate())
                                .isSingle(sendOnion.getOnion().getIsSingle())
                                .receiverNumber(sendOnion.getReceiverNumber())
                                .build();
                        sendOnionResponses.add(sendOnionResponse);
                    }
                }
                return ResponseEntity.ok(sendOnionResponses);
            } catch (SendOnionNotFoundException e) {
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    // 내가 받은 양파 보기(양파 상세)

    // 특정 양파의 위치를 옮기기(밭A -> 밭B)


    // 양파 삭제에는 2가지가 있다.
    // 1. 만들고 있는 양파를 삭제하는 것
    // 2. 받은 양파를 삭제하는 것
    // -> 실제론 DB에서 삭제하는 것이 아니다. disabled true만 해주게 된다.
//    @DeleteMapping("/{onionId}")
//    public ResponseEntity<Boolean> deleteOnion(
//            @PathVariable Long onionId) {
//        // **생략**auth check
//        // 보내기 전 -> 양파 생성자
//        // 보내고 난 후 -> 양파 받은 사람
//        // 가 삭제의 권한을 갖는다.
//        // **인증 후의 과정
//    }
}
