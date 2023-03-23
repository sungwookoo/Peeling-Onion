package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.onion.domain.SendOnion;

import java.util.List;

public interface SendOnionRepository extends JpaRepository<SendOnion, Long> {
    List<SendOnion> findALlByUserIdAndIsSended(Long userId, Boolean isSended);
}