package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.field.domain.MyField;

public interface MyFieldRepository extends JpaRepository<MyField, Long> {
}