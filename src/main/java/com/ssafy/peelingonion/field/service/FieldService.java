package com.ssafy.peelingonion.field.service;

import static com.ssafy.peelingonion.common.ConstValues.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.ssafy.peelingonion.onion.domain.ReceiveOnion;
import com.ssafy.peelingonion.onion.domain.ReceiveOnionRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.ssafy.peelingonion.field.controller.dto.FieldCreateRequest;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.domain.FieldRepository;
import com.ssafy.peelingonion.field.domain.MyField;
import com.ssafy.peelingonion.field.domain.MyFieldRepository;
import com.ssafy.peelingonion.field.domain.Storage;
import com.ssafy.peelingonion.field.domain.StorageRepository;
import com.ssafy.peelingonion.onion.domain.Onion;

import reactor.core.publisher.Mono;

@Service
public class FieldService {
	private final FieldRepository fieldRepository;
	private final MyFieldRepository myFieldRepository;
	private final StorageRepository storageRepository;
	public FieldService(FieldRepository fieldRepository,
						MyFieldRepository myFieldRepository,
						StorageRepository storageRepository,
						ReceiveOnionRepository receiveOnionRepository) {
		this.fieldRepository = fieldRepository;
		this.myFieldRepository = myFieldRepository;
		this.storageRepository = storageRepository;
	}

	public Field createField(FieldCreateRequest fieldCreateReuqest, Long userId) {
		// Field 객체 생성 후, 저장
		Field field = Field.builder()
			.name(fieldCreateReuqest.getName())
			.isDisabled(Boolean.FALSE)
			.createdAt(Instant.now())
			.build();
		fieldRepository.save(field);
		// myField 객체 생성 후, 저장
		// default 밭 생성인 경우
		MyField myField;
		if (!myFieldRepository.existsByUserId(userId)) {
			myField = MyField.builder()
				.userId(userId)
				.field(field)
				.isDefault(true)
				.build();
		} else { // 추가적인 밭 생성인 경우
			myField = MyField.builder()
				.userId(userId)
				.field(field)
				.isDefault(false)
				.build();
		}
		myFieldRepository.save(myField);
		return field;
	}

	public List<Field> readAllFields(Long userId) {
		List<MyField> myFields = myFieldRepository.findAllByUserId(userId);
		List<Field> fields = new ArrayList<>();
		if(!myFields.isEmpty()) {
			for (MyField myField : myFields) {
				fieldRepository.findByIdAndIsDisabled(myField.getField().getId(), Boolean.FALSE)
						.ifPresent(fields::add);
			}
		}
		return fields;
	}

	public Field updateField(Long fieldId, String updateName) {
		Field field = fieldRepository.findById(fieldId).get();
		field.setName(updateName);
		return fieldRepository.save(field);
	}

	public void deleteField(Long fieldId) {
		Field field = fieldRepository.findById(fieldId).get();
		field.setIsDisabled(Boolean.TRUE);
		fieldRepository.save(field);
	}

	/**
	 * User Service와 통신하여 userId로 nickname을 반환
	 * @param userId
	 * @return
	 */
	public String getNameByUserId(Long userId) {
		try {
			return USER_SERVER_CLIENT.get()
				.uri("/user/" + userId.toString() + "/nickname")
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(String.class)
				.block();
		} catch (Exception e) {
			return "";
		}
	}

	public List<Storage> findStorages(Long fieldId) {
		return storageRepository.findAllByFieldId(fieldId);
	}

	/**
	 * fieldId에 속한 모든 Onion 객체를 반환
	 * @param fieldId
	 * @return
	 */
	public List<Onion> findOnionListByFieldId(Long fieldId) {
		return storageRepository.findAllByFieldId(fieldId)
			.stream()
			.map(Storage::getOnion)
			.collect(Collectors.toList());
	}
}
