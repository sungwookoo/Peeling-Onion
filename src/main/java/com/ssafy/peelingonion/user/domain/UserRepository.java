package com.ssafy.peelingonion.user.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.user.domain.User;

public interface UserRepository extends JpaRepository<User, Long> {
}