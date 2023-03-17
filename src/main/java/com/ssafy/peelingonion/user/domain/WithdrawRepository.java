package com.ssafy.peelingonion.user.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.user.domain.Withdraw;

public interface WithdrawRepository extends JpaRepository<Withdraw, Long> {
}