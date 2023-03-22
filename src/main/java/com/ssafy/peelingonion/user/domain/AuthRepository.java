package com.ssafy.peelingonion.user.domain;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface AuthRepository extends JpaRepository<Auth, Long> {
	Optional<Auth> findByUserId(Long userId);
}