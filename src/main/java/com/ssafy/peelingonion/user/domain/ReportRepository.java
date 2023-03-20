package com.ssafy.peelingonion.user.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.user.domain.Report;

public interface ReportRepository extends JpaRepository<Report, Long> {
}