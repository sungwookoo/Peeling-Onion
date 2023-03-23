package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.onion.domain.ReceiveOnion;

import java.util.List;

public interface ReceiveOnionRepository extends JpaRepository<ReceiveOnion, Long> {
    ReceiveOnion findByOnion(Onion onion);
    List<ReceiveOnion> findALlByUserIdAndIsReceivedAndIsChecked(Long userId, Boolean isReceived, Boolean isChecked);
}