package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.onion.controller.dto.*;
import com.ssafy.peelingonion.onion.domain.Message;
import com.ssafy.peelingonion.onion.domain.Onion;
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
import java.util.Set;

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
     * Home화면에서 새롭게 양파를 생성한다.
     * @param token 로그인 유저의 토큰
     * @param onionCreateRequest 양파를 생성하기 위해 필요한 요청 정보
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
     * Home화면에서 내가 키우는 모든 양파를 보여주는 API
     * @param token 로그인 유저의 토큰
     * 전송 여부, 삭제 여부를 판단하여 전송하지 않았고, 삭제되지 않는 양파들의 리스트를 보내준다.
     * @return 키우고 있는 양파 리스트
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
     * Home화면에서 양파에 메시지를 추가한다.
     * @param token 로그인한 유저의 양파 정버
     * @param messageCreateRequest 양파에 메시지를 추가하기 위해서 필요한 요청 정보
     * @return 메세지 생성 성공 여부
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
     * Home화면에서 다 키운 양파를 보낸다.
     * @param token 로그인 유저의 토큰
     * @param onionId 보내지는 양파 id
     * @return 송신 성공 여부
     */
    @PostMapping("/growing/throw/{onionId}")
    public ResponseEntity<Boolean> throwOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.throwOnion(onionId);
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
     * Home화면에서 키우고 있는 양파를 삭제
     * @param token 로그인 유저의 토큰
     * @param onionId 키우고 있는 양파 중, 삭제할 양파의 id
     * 해당 양파를 isDisable True로 바꿔서 더 이상 보이지 않도록 한다.
     * @return 양파 삭제 성공 여부
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
     * 택배함에서 양파를 확인(나에게 보낸 양파중, 상대방이 보낸 양파와 아직 읽지않은 양파만)
     * @param token 로그인 유저의 토큰
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
                String userName = onionService.getNameByUserId(userId);
                for(ReceiveOnion receiveOnion : receiveOnions){
                    ReceiveOnionResponse receiveOnionResponse = ReceiveOnionResponse.builder()
                            .id(receiveOnion.getOnion().getId())
                            .name(receiveOnion.getOnion().getImgSrc())
                            .receiveDate(receiveOnion.getOnion().getSendDate())
                            .sender(userName)
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

    /**
     * 택배함 화면 or 밭에서 양파 세부사항 읽기(아이디까지 받아옴)
     * @param token 로그인 유저의 토큰
     * @param onionId 택배함에서 선택한 양파의 id
     * @return 양파의 정보들과 안에 들어있는 메시지 아이디(-> 메세지 읽을 때 따로)
     */
    @GetMapping("/{onionId}")
    public ResponseEntity<OnionDetailResponse> readOnionDetail(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)){
            try {
                Onion onion = onionService.findOnionById(onionId);
                if(onion.getIsDisabled() != Boolean.TRUE) {
                    ReceiveOnion receiveOnion = onionService.findReceiveOnionByOnionId(onionId);
                    List<Long> messageIdList = new ArrayList<>();
                    Set<Message> messages = onion.getMessages();
                    String userName = onionService.getNameByUserId(userId);
                    for(Message message : messages) {
                        messageIdList.add(message.getId());
                    }
                    OnionDetailResponse onionDetailResponse = OnionDetailResponse.builder()
                            .id(onion.getId())
                            .name(onion.getName())
                            .imgSrc(onion.getImgSrc())
                            .sender(userName)
                            .createdAt(onion.getCreatedAt())
                            .sendDate(onion.getSendDate())
                            .growDueDate(onion.getGrowDueDate())
                            .isSingle(onion.getIsSingle())
                            .isBookmarked(receiveOnion.getIsBookmarked())
                            .messageIdList(messageIdList)
                            .build();
                    return ResponseEntity.ok(onionDetailResponse);
                }
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            } catch (Exception e){
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 양파를 까면서 메세지를 확인하는 API
     * @param token 로그인 유저의 토큰
     * @param messageId 읽을 메세지 id
     * @return 해당 메시지 읽기위해서 필요한 정보(Text, S3에 저장된 녹음 정보의 위치)
     */
    @GetMapping("/{messageId}")
    public ResponseEntity<MessageDetailResponse> readMessageDetail(
            @RequestHeader("Authorization") String token,
            @PathVariable Long messageId) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                Message message = onionService.findMessageById(messageId);
                String userName = onionService.getNameByUserId(userId);
                MessageDetailResponse messageDetailResponse = MessageDetailResponse.builder()
                        .id(messageId)
                        .sender(userName)
                        .createdAt(message.getCreatedAt())
                        .posRate(message.getPosRate())
                        .negRate(message.getNegRate())
                        .fileSrc(message.getRecord().getFileSrc())
                        .build();
                return ResponseEntity.ok(messageDetailResponse);
            } catch (Exception e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 받은 양파를 삭제하는 API
     * @param token 로그인한 유저의 토큰
     * @param onionId 삭제할 양파의 id
     * @return 삭제 성공 여부
     */
    @DeleteMapping("/{onionId}")
    public ResponseEntity<Boolean> deleteOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                onionService.deleteOnion(onionId);
                return ResponseEntity.ok().build();
            } catch (Exception e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 받은 양파에 즐겨찾기 하는 API(Put)
     * @param token 로그인 유저의 토큰
     * @param onionId 북마크 할 양파의 id
     * @return 즐겨찾기 성공 여부
     */
    @PutMapping("/{onionId}/bookmark")
    public ResponseEntity<Boolean> bookmarkOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                onionService.bookmarkOnion(onionId);
                return ResponseEntity.ok().build();
            } catch (Exception e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }

    /**
     * 받은 양파의 밭을 옮기는 API(storage 수정)
     * @param token 로그인 유저의 토큰
     * @param fromFId 양파가 있던 기존의 밭 id
     * @param toFId 양파가 이동할 밭 id
     * @param onionId 이동하는 양파의 id
     * @return 양파 이동의 성공 여부
     */
    @PutMapping("/{fromFId}/{toFId}/{onionId}/transfer")
    public ResponseEntity<Boolean> transferOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long fromFId,
            @PathVariable Long toFId,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)) {
            try {
                onionService.transferOnion(fromFId, toFId, onionId);
                return ResponseEntity.ok().build();
            } catch (Exception e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NOT_ACCEPTABLE).build();
        }
    }
}