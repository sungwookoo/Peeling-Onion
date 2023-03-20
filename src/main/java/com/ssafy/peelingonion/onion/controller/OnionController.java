package com.ssafy.peelingonion.onion.controller;

import com.ssafy.peelingonion.onion.controller.dto.MessageCreateRequestDto;
import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequestDto;
import com.ssafy.peelingonion.onion.controller.dto.OnionDeleteRequestDto;
import com.ssafy.peelingonion.onion.service.exceptions.OnionNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import com.ssafy.peelingonion.onion.service.OnionService;

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
    @PostMapping("/")
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
     * 양파 삭제
     * @param onionDeleteRequestDto
     * @return bool
     */
    @DeleteMapping("/")
    public ResponseEntity<Boolean> deleteOnion(
            @RequestBody OnionDeleteRequestDto onionDeleteRequestDto) {
            // 1. auth check -> 인증 여부에 따라 다른 응답
            final String uri = "~~~~";

            // 2. 인증이 되었을 경우
            try {
                onionService.deleteOnion(onionDeleteRequestDto);
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
