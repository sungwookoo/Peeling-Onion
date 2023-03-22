package com.ssafy.peelingonion.field.service;

import com.ssafy.peelingonion.field.controller.dto.FieldCreateRequestDto;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.domain.FieldRepository;
import com.ssafy.peelingonion.field.domain.Storage;
import com.ssafy.peelingonion.field.domain.StorageRepository;

import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.*;

@Service
public class FieldService {
	private final FieldRepository fieldRepository;
	private final StorageRepository storageRepository;

	public FieldService(FieldRepository fieldRepository, StorageRepository storageRepository) {
		this.fieldRepository = fieldRepository;
		this.storageRepository = storageRepository;
	}

	public Field createField(FieldCreateRequestDto fieldCreateRequestDto) {
		// 필드를 먼저 만들고 저장 후 반환
		Field field = new Field();
		field.builder()
			.name(fieldCreateRequestDto.getName())
			.createdAt(Instant.now())
			.isDisabled(Boolean.FALSE)
			.build();
		return fieldRepository.save(field);
	}

	// 유저아이디를 받아서 유저아이디에 해당하는 양파 id와 밭id를 찾는다.
	public Map<Long, List<Storage>> readFields(Long userId) {
		Map<Long, List<Storage>> fieldOnionsMap = new HashMap<Long, List<Storage>>();
		// 유저 아이디로 모든 필드아이디를 찾기(Set을 통해서 중복을 제거)
		Set<Long> myFieldId = storageRepository.findAllFieldIdByUserId(userId);
		for (Long fId : myFieldId) {
			List<Storage> storagesByFid = storageRepository.findAllByFieldId(fId);
			// id : List 형태로 Map에 저장
			fieldOnionsMap.put(fId, storagesByFid);
		}
		return fieldOnionsMap;
	}
}
