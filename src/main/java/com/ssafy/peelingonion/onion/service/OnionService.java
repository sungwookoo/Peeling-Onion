package com.ssafy.peelingonion.onion.service;

import com.ssafy.peelingonion.onion.controller.dto.MessageCreateRequestDto;
import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequestDto;
import com.ssafy.peelingonion.onion.domain.Message;
import com.ssafy.peelingonion.onion.domain.MessageRepository;
import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.OnionRepository;
import com.ssafy.peelingonion.onion.service.exceptions.OnionNotFoundException;
import com.ssafy.peelingonion.record.domain.RecordedVoice;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class OnionService {
    private final OnionRepository onionRepository;
    private final MessageRepository messageRepository;

    public OnionService(OnionRepository onionRepository,
                        MessageRepository messageRepository) {
        this.onionRepository = onionRepository;
        this.messageRepository = messageRepository;
    }

    /**
     * 양파 생성
     * @param onionCreateRequestDto
     */
    public void createOnion(OnionCreateRequestDto onionCreateRequestDto){
        Onion newOnion = Onion.builder()
                .onionName(onionCreateRequestDto.onion_name)
                .mobileNumber(onionCreateRequestDto.mobile_number)
                .imgSrc(onionCreateRequestDto.img_src)
                .growDueDate(onionCreateRequestDto.grow_due_date.toInstant())
                .createdAt(Instant.now())
                .isDisabled(Boolean.FALSE)
                .build();
        // ****나중에 해야할 것****
        // 토큰 값으로 대표자 찾기
        // -> 찾은 값을 양파.userId에 집어넣기
        onionRepository.save(newOnion);
    }

    /**
     * 양파 읽기
     * @param onionId
     */
    public Onion readOnion(Long onionId){
        Onion onion = onionRepository.findOnionById(onionId)
                .orElseThrow(OnionNotFoundException::new);
        return onion;
    }

    /**
     * 양파 삭제
     * @param onionId
     */
    public void deleteOnion(Long onionId){
        Onion onion = onionRepository.findOnionById(onionId)
                .orElseThrow(OnionNotFoundException::new);
        onion.setIsDisabled(Boolean.TRUE);
    }

    /**
     * 양파 겹 생성(녹음 하나)
     * @param messageCreateRequestDto
     * @param userId
     */
    public void createMessage(MessageCreateRequestDto messageCreateRequestDto, Long userId){
        Onion onion = onionRepository.findOnionById(messageCreateRequestDto.onion_id)
                .orElseThrow(OnionNotFoundException::new);
        // 레코드 레포지터리에 접근해서 하나를 저장(새로운 녹음 정보를 만들어서 이때 저장 시킨다.)
        RecordedVoice newRecordedVoice = RecordedVoice.builder()
                .createdAt(Instant.now())
                .fileSrc(messageCreateRequestDto.file_src)
                .userId(userId)
                .build();

        Message newMessage = Message.builder()
                .createdAt(Instant.now())
                .userId(userId)
                .content(messageCreateRequestDto.content)
                .posRate(messageCreateRequestDto.pos_rate)
                .negRate(messageCreateRequestDto.neg_rate)
                .onion(onion)
                .recordedVoice(newRecordedVoice)
                .build();

        messageRepository.save(newMessage);
    }
}
