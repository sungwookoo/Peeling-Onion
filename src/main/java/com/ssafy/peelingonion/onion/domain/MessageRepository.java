package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.onion.domain.Message;

public interface MessageRepository extends JpaRepository<Message, Long> {
}