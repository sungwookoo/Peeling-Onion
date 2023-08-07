package com.ssafy.peelingonion.record.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.record.domain.Record;

public interface RecordRepository extends JpaRepository<Record, Long> {
}