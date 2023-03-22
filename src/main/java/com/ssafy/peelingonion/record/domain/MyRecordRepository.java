package com.ssafy.peelingonion.record.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.record.domain.MyRecord;

public interface MyRecordRepository extends JpaRepository<MyRecord, Long> {
}