package com.ssafy.peelingonion.field.domain;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Set;

public interface StorageRepository extends JpaRepository<Storage, Long> {
    List<Storage> findAllByUserId(Long userId);
    Set<Long> findAllFieldIdByUserId(Long userId);
    List<Storage> findAllByFieldId(Long fieldId);
}