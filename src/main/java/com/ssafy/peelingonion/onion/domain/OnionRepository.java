package com.ssafy.peelingonion.onion.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OnionRepository extends JpaRepository<Onion, Long> {
    Optional<Onion> findOnionById(Long id);
}