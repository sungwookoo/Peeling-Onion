package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.field.domain.Field;

public interface FieldRepository extends JpaRepository<Field, Long> {
}