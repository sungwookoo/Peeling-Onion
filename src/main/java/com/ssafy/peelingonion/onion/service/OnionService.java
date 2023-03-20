package com.ssafy.peelingonion.onion.service;

import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequestDto;
import com.ssafy.peelingonion.onion.controller.dto.OnionDeleteRequestDto;
import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.OnionRepository;
import com.ssafy.peelingonion.onion.service.exceptions.OnionNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class OnionService {
    private final OnionRepository onionRepository;

    public OnionService(OnionRepository onionRepository) {
        this.onionRepository = onionRepository;
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
                .isDisabled(Boolean.FALSE)
                .build();
        // ****나중에 해야할 것****
        // 토큰 값으로 대표자 찾기
        // -> 찾은 값을 양파.userId에 집어넣기
        onionRepository.save(newOnion);
    }

    /**
     * 양파 삭제 : 양파를 삭제하는 대신, disabled를 true로 바꿔서 이용자가 활용하지 못하게 한다.
     * @param onionDeleteRequestDto
     */
    public void deleteOnion(OnionDeleteRequestDto onionDeleteRequestDto){
        Onion onion = onionRepository.findOnionById(onionDeleteRequestDto.onion_id)
                .orElseThrow(OnionNotFoundException::new);
        onion.setIsDisabled(Boolean.TRUE);
    }
}
