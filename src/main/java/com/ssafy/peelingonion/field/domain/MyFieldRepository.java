package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MyFieldRepository extends JpaRepository<MyField, Long> {
	List<MyField> findAllByUserId(Long userid);

	Optional<MyField> findByUserIdAndIsDefault(Long userId, Boolean isDefault);

	boolean existsByUserId(Long userId);
}