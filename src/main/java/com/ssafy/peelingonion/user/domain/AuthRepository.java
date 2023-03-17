package com.ssafy.peelingonion.user.domain;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthRepository extends JpaRepository<Auth, Long> {
}