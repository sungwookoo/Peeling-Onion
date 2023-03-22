package com.ssafy.peelingonion.auth.domain;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
	Optional<Long> findIdByKakaoId(Long kakaoId);
}