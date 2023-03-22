package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.field.domain.MyField;

import java.util.List;

public interface MyFieldRepository extends JpaRepository<MyField, Long> {
    List<MyField> findAllByUserId(Long userid);
}