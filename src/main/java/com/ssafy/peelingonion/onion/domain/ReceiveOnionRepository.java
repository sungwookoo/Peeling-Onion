package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReceiveOnionRepository extends JpaRepository<ReceiveOnion, Long> {
    ReceiveOnion findByOnion(Onion onion);
    List<ReceiveOnion> findAllByReceiverNumberAndIsReceivedAndIsChecked(String receiveNumber, Boolean isReceived, Boolean isChecked);

    List<ReceiveOnion> findByUserIdAndIsBookmarked(Long userId, Boolean isBookmarked);
}