package com.ssafy.peelingonion.onion.service;

import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
import com.ssafy.peelingonion.onion.domain.Onion;
import com.ssafy.peelingonion.onion.domain.OnionRepository;
import com.ssafy.peelingonion.onion.domain.SendOnion;
import com.ssafy.peelingonion.onion.domain.SendOnionRepository;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
public class OnionService {
    private final OnionRepository onionRepository;
    private final SendOnionRepository sendOnionRepository;

    public OnionService(OnionRepository onionRepository, SendOnionRepository sendOnionRepository) {
        this.onionRepository = onionRepository;
        this.sendOnionRepository = sendOnionRepository;
    }

    public void createOnion(OnionCreateRequest onionCreateRequest, Long userId){
        Onion onion = Onion.builder()
                .name(onionCreateRequest.getOnionName())
                .imgSrc(onionCreateRequest.getImgSrc())
                .userId(userId)
                .createdAt(Instant.now())
                .latestModify(Instant.now())
                .growDueDate(onionCreateRequest.getGrowDueDate())
                .isDisabled(Boolean.FALSE)
                .isSingle(onionCreateRequest.getIsSingle())
                .build();
        Onion newOnion = onionRepository.save(onion);

        List<Long> senderIds = onionCreateRequest.getUserIdList();
        for(Long senderId : senderIds){
            SendOnion sendOnion = SendOnion.builder()
                    .userId(senderId)
                    .receiverNumber(onionCreateRequest.getReciverNumber())
                    .isSended(Boolean.FALSE)
                    .onion(newOnion)
                    .build();
            sendOnionRepository.save(sendOnion);
        }
    }

    public List<SendOnion> findSendOnions(Long userId) {
        return sendOnionRepository.findALlByUserIdAndIsSended(userId, Boolean.FALSE);
    }
}
