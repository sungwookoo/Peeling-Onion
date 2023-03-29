package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MyFieldRepository extends JpaRepository<MyField, Long> {
	List<MyField> findAllByUserId(Long userid);

	MyField findByUserIdAndIsDefault(Long userId, Boolean isDefault);

	boolean existsByUserId(Long userId);
}