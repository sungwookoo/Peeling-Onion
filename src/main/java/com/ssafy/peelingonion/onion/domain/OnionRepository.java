package com.ssafy.peelingonion.onion.domain;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.onion.domain.Onion;

public interface OnionRepository extends JpaRepository<Onion, Long> {
	Optional<Onion> findOnionById(Long onionId);
}