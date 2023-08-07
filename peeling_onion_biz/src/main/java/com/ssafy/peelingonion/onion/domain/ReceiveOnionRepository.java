package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ReceiveOnionRepository extends JpaRepository<ReceiveOnion, Long> {
    ReceiveOnion findByOnion(Onion onion);

    ReceiveOnion findByOnionId(Long onionId);
    Optional<ReceiveOnion> findByOnionIdAndIsReceived(Long onionId, Boolean isReceived);
    List<ReceiveOnion> findAllByReceiverNumberAndIsReceivedAndIsChecked(String receiveNumber, Boolean isReceived, Boolean isChecked);

    List<ReceiveOnion> findByReceiverNumberAndIsBookmarked(String receiverNumber, Boolean isBookmarked);
}