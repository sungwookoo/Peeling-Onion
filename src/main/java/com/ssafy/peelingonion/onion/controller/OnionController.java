package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.field.controller.dto.OnionOutlineDto;
import com.ssafy.peelingonion.field.service.exceptions.FieldNotFoundException;
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
@RequestMapping("/onion")
public class OnionController {

    private final OnionService onionService;
    private final AuthorizeService authorizeService;

    @Autowired
    public OnionController(OnionService onionService, AuthorizeService authorizeService) {
        this.onionService = onionService;
        this.authorizeService = authorizeService;
    }

    /**
     * 양파 생성
     * @param token 로그인 유저의 토큰
     * @param onionCreateRequest 양파를 생성하기 위해 필요한 요청 정보
     * @return 생성 여부만 확인해준다.
     */
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
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
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
                    ReceiveOnion receiveOnion = onionService.findReceiveOnionByOnionId(userId, onionId);
                    List<Long> messageIdList = new ArrayList<>();
                    Set<Message> messages = onion.getMessages();
                    String userName = onionService.getNameByUserId(userId);
                    for(Message message : messages) {
                        messageIdList.add(message.getId());
                    }
                    return ResponseEntity.ok(OnionDetailResponse.from(onion, receiveOnion, userName, messageIdList));
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
     * 즐겨찾기한 양파들을 확인하는 것
     * @param token 로그인 유저의 토큰
     * @return 즐겨찾기한 양파들의 대략 정보
     */
    @GetMapping("/bookmarked")
    public ResponseEntity<List<OnionOutlineDto>> readBookmarkedOnions(
            @RequestHeader("Authorization") String token) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                List<OnionOutlineDto> onionOutlineDtos = new ArrayList<>();
                List<ReceiveOnion> receiveOnions = onionService.findBookmarkedOnions(userId);
                String userName = onionService.getNameByUserId(userId);
                for(ReceiveOnion receiveOnion : receiveOnions) {
                    onionOutlineDtos.add(OnionOutlineDto.from(receiveOnion, userName));
                }
                return ResponseEntity.ok(onionOutlineDtos);
            } catch(FieldNotFoundException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
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
    @PostMapping("/{onionId}/bookmark")
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
     * 양파 삭제
     * @param token 로그인 유저의 토큰
     * @param onionId 키우고 있는 양파 중, 삭제할 양파의 id
     * 해당 양파를 isDisable True로 바꿔서 더 이상 보이지 않도록 한다.
     * @return 양파 삭제 성공 여부
     */
    @DeleteMapping("/{onionId}")
    public ResponseEntity<Boolean> deleteOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.deleteOnion(onionId);
                return ResponseEntity.ok().build();
            } catch (DeleteOnionFailException e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
            }
        } else {
            return ResponseEntity.status(HttpStatus.NON_AUTHORITATIVE_INFORMATION).build();
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
                    if(sendOnion.getOnion().getIsDisabled() == Boolean.FALSE) {
                        sendOnionResponses.add(SendOnionResponse.from(sendOnion));
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
    @PostMapping("/message")
    public ResponseEntity<Boolean> recordMessage(
            @RequestHeader("Authorization") String token,
            @RequestBody MessageCreateRequest messageCreateRequest) {
        final Long userId = authorizeService.getAuthorization(token);
        if(authorizeService.isAuthorization(userId)){
            try {
                onionService.recordMessage(messageCreateRequest, userId);
                return ResponseEntity.status(HttpStatus.CREATED).build();
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
    @PostMapping("/growing/send/{onionId}")
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
     * 택배함에서 양파를 확인(나에게 보낸 양파중, 상대방이 보낸 양파와 아직 읽지않은 양파만)
     * @param token 로그인 유저의 토큰
     * @return 택배함의 양파들을 구성하는데에 필요한 양파의 정보
     */
    @GetMapping("/postbox")
    public ResponseEntity<List<ReceiveOnionResponse>> readReceiveOnions(
            @RequestHeader("Authorization") String token) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                List<ReceiveOnionResponse> receiveOnionResponses = new ArrayList<>();
                List<ReceiveOnion> receiveOnions = onionService.findReceiveOnions(onionService.getMobileNumberByUserId(userId));
                for(ReceiveOnion receiveOnion : receiveOnions){
                    String senderName = onionService.getNameByUserId(receiveOnion.getUserId());
                    receiveOnionResponses.add(ReceiveOnionResponse.from(receiveOnion, senderName));
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
     * 양파를 까면서 메세지를 확인하는 API
     * @param token 로그인 유저의 토큰
     * @param messageId 읽을 메세지 id
     * @return 해당 메시지 읽기위해서 필요한 정보(Text, S3에 저장된 녹음 정보의 위치)
     */
    @GetMapping("/message/{messageId}")
    public ResponseEntity<MessageDetailResponse> readMessageDetail(
            @RequestHeader("Authorization") String token,
            @PathVariable Long messageId) {
        final Long userId = authorizeService.getAuthorization(token);
        if (authorizeService.isAuthorization(userId)) {
            try {
                Message message = onionService.findMessageById(messageId);
                String userName = onionService.getNameByUserId(userId);
                return ResponseEntity.ok(MessageDetailResponse.from(messageId, userName, message));
            } catch (Exception e) {
                log.error(e.getMessage());
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
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
    @PutMapping("/{onionId}/{fromFId}/{toFId}")
    public ResponseEntity<Boolean> transferOnion(
            @RequestHeader("Authorization") String token,
            @PathVariable Long onionId,
            @PathVariable Long fromFId,
            @PathVariable Long toFId) {
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