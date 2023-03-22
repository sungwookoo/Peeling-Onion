package com.ssafy.peelingonion.user.domain;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
	boolean existsByNickname(String nickname);

	Optional<User> findById(Long id);

	Optional<User> findByMobileNumber(String mobileNumber);

	List<User> findTop10ByNicknameLike(String nickname);

}