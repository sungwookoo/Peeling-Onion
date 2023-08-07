package com.ssafy.peelingonion.field.domain;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ssafy.peelingonion.field.domain.Storage;

public interface StorageRepository extends JpaRepository<Storage, Long> {
	List<Storage> findAllByFieldId(Long fId);
	Optional<Storage> findByFieldIdAndOnionId(Long fieldId, Long onionId);
}