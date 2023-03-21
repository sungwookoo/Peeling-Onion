package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.onion.controller.dto.*;
import com.ssafy.peelingonion.onion.domain.Message;
import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.service.exceptions.OnionNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import com.ssafy.peelingonion.onion.service.OnionService;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@RestController
@RequestMapping("/v1/onion")
public class OnionController {
    private final OnionService onionService;

    @Autowired
    public OnionController(OnionService onionService) {
        this.onionService = onionService;
    }

    /**
     * 양파 생성
     * @param onionCreateRequestDto
     * @return bool
     */
    @PostMapping("")
    public ResponseEntity<Boolean> createOnion(
            @RequestBody OnionCreateRequestDto onionCreateRequestDto) {
            // 1. auth check -> 인증 여부에 따라 다른 응답
            final String uri = "~~~~";

            // 2. 인증이 되었을 경우
            try {
                onionService.createOnion(onionCreateRequestDto);
                return ResponseEntity.ok().build();
            } catch (Exception e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
    }

    /**
     * 양파 읽기
     * @param onionId
     * @return
     */
    @GetMapping("/{onionId}")
    public ResponseEntity<OnionReadResponseDto> readOnion(@PathVariable Long onionId){
            // 1. auth check -> 인증 여부에 따라 다른 응답
            final String uri = "~~~~";

            // 2. 인증이 되었을 경우
            try{
                Onion onion = onionService.readOnion(onionId);
                Set<Message> messages = onion.getMessages();
                Set<MessageSmallDto> messageSmallDtos = messagesToSmallDtos(messages);
                return ResponseEntity.ok(OnionReadResponseDto.makeOnionReadDto(onion, messageSmallDtos));
            } catch(Exception e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
    }

    /**
     * 메세지 set를 메세지Dto set으로 바꿈
     * @param messages
     * @return
     */
    public Set<MessageSmallDto> messagesToSmallDtos(Set<Message> messages) {
        Set<MessageSmallDto> messageSmallDtos = new LinkedHashSet<>();
        for(Message message : messages) {
            String nickName = findNickName(message.getUserId());
            messageSmallDtos.add(MessageSmallDto.makeSmallMDto(message, nickName));
        }
        return messageSmallDtos;
    }

    /**
     * 유저 id로 유저의 닉네임을 찾는 함수
     * @param userId
     * @return
     */
    public String findNickName(Long userId){
        // **차 후에 할 것 : 유저 아키텍처에 요청
        // **유저 닉네임을 받기 : 아래는 더미 데이터
        String nickName = "zzangbae";
        return nickName;
    }

    // -> 맵을 이용하여 한 번의 쿼리로 활용하면 좋지 않을까....????
//    public Map<>
//    }

    /**
     * 양파 삭제
     * @param onionId
     * @return bool
     */
    @DeleteMapping("/{onionId}")
    public ResponseEntity<Boolean> deleteOnion(@PathVariable Long onionId) {
            // 1. auth check -> 인증 여부에 따라 다른 응답
            final String uri = "~~~~";

            // 2. 인증이 되었을 경우
            try {
                onionService.deleteOnion(onionId);
                return ResponseEntity.ok().build();
            } catch (OnionNotFoundException e){
                log.info(e.getMessage());
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
    }

    @PostMapping("/d")
    public ResponseEntity<Boolean> createMessage(
            @RequestBody MessageCreateRequestDto messageCreateRequestDto) {

            // ***auth 구성 후 해야할 부분***
            // 1. auth check -> 인증 여부에 따른 다른 응답(유효성 검증)
            final String uri = "~~~~";

            // 1-2. 유효하다 -> 요청을 한 사람이 누군지 식별이 가능하다.
            // 1-3. payload에 user_id에 있을 것 ...
            // 더미 데이터
            final Long userId = 123L;

            // 2. 인증이 되었을 경우
            try {
                onionService.createMessage(messageCreateRequestDto, userId);
                return ResponseEntity.ok().build();
            } catch (OnionNotFoundException e){
                log.info(e.getMessage());
                // ***나중에 에러 값을 더 찾아봐야함***
                return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
            }
    }
}
