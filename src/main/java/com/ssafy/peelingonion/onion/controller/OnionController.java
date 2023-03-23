package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.onion.controller.dto.MessageCreateRequest;
import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
import com.ssafy.peelingonion.onion.controller.dto.ReceiveOnionResponse;
import com.ssafy.peelingonion.onion.controller.dto.SendOnionResponse;
import com.ssafy.peelingonion.onion.domain.ReceiveOnion;
import com.ssafy.peelingonion.onion.domain.SendOnion;
import com.ssafy.peelingonion.onion.service.OnionService;
import com.ssafy.peelingonion.onion.service.exceptions.*;
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

    /**
     * Home화면 : 새롭게 양파를 생성한다.
     * @param token
     * @param onionCreateRequest
     * @return 생성 여부만 확인해준다.
     */
    @PostMapping("/growing")
    public ResponseEntity<Boolean> createOnion(
            @RequestHeader("Authorization") String token,
            @RequestBody OnionCreateRequest onionCreateRequest) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.createOnion(onionCreateRequest, userId);
                return ResponseEntity.status(HttpStatus.CREATED).build();
            } catch (OnionNotCreatedException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    /**
     * Home화면 : 내가 키우는 모든 양파를 보여준다.
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
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        }
    }

    /**
     * Home화면 : 양파에 메시지를 추가한다.
     * @param token
     * @param messageCreateRequest
     * @return 성공 여부만 리턴한다.
     */
    @PostMapping("/growing/record")
    public ResponseEntity<Boolean> recordMessage(
            @RequestHeader("Authorization") String token,
            @RequestBody MessageCreateRequest messageCreateRequest) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.recordMessage(messageCreateRequest, userId);
                return ResponseEntity.ok().build();
            } catch (MessageNotCreatedException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * Home화면 : 다 키운 양파를 보낸다.
     * @param token
     * @param onionId
     * @return
     */
    @PostMapping("/growing/throw/{onionId}")
    public ResponseEntity<Boolean> throwOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.throwOnion(onionId, userId);
                return ResponseEntity.ok().build();
            } catch (ThrowOnionFailException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * Home화면 : 키우고 있는 양파를 삭제한다.
     * @param token
     * @param onionId
     * @return 해당 양파를 isDisable True로 바꿔서 더 이상 보이지 않도록 한다.
     */
    @DeleteMapping("/growing/delete/{onionId}")
    public ResponseEntity<Boolean> deleteGrowingOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.deleteGrowingOnion(onionId);
                return ResponseEntity.ok().build();
            } catch (DeleteOnionFailException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 택배함 화면 : 택배함에서 양파를 확인할 수 있다.(나에게 보낸 양파중, 상대방이 보낸 양파와 아직 읽지않은 양파만)
     * @param token
     * @return 택배함의 양파들을 구성하는데에 필요한 양파의 정보
     */
    @GetMapping("/delivery")
    public ResponseEntity<List<ReceiveOnionResponse>> readReceiveOnions(
            @RequestHeader("Authorization") String token) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                List<ReceiveOnionResponse> receiveOnionResponses = new ArrayList<>();
                List<ReceiveOnion> receiveOnions = onionService.findReceiveOnions(userId);
                for(ReceiveOnion receiveOnion : receiveOnions){
                    ReceiveOnionResponse receiveOnionResponse = ReceiveOnionResponse.builder()
                            .id(receiveOnion.getOnion().getId())
                            .name(receiveOnion.getOnion().getImgSrc())
                            .receiveDate(receiveOnion.getOnion().getSendDate())
                            .sender("zzangbae_dummydata")
                            .isSingle(receiveOnion.getOnion().getIsSingle())
                            .createdAt(receiveOnion.getOnion().getCreatedAt())
                            .growDueDate(receiveOnion.getOnion().getGrowDueDate())
                            .build();
                    receiveOnionResponses.add(receiveOnionResponse);
                }
                return ResponseEntity.ok(receiveOnionResponses);
            } catch (ReceiveOnionNotFoundException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

//    @GetMapping("/delivery/{onionId}")
}
