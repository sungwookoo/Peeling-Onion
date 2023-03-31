package com.ssafy.peelingonion.domain;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AlarmRepository extends JpaRepository<Alarm, Long> {
	List<Alarm> findByReceiverIdOrderByIdDesc(Long receiverId);
	List<Alarm> findByIsSended(boolean isSended);
}