package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.onion.domain.ReceiveOnion;

import java.util.List;
import java.util.Optional;

public interface ReceiveOnionRepository extends JpaRepository<ReceiveOnion, Long> {
    ReceiveOnion findByOnion(Onion onion);
    List<ReceiveOnion> findALlByUserIdAndIsReceivedAndIsChecked(Long userId, Boolean isReceived, Boolean isChecked);

    List<ReceiveOnion> findByUserIdAndIsBookmarked(Long userId, Boolean isBookmarked);
}