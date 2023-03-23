package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.field.controller.dto.*;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.service.FieldService;
import com.ssafy.peelingonion.field.service.exceptions.*;
import com.ssafy.peelingonion.onion.domain.Onion;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequestMapping("/onion/field")
public class FieldController {

	private final FieldService fieldService;
	private final AuthorizeService authorizeService;

	@Autowired
	public FieldController(FieldService fieldService, AuthorizeService authorizeService) {
		this.fieldService = fieldService;
		this.authorizeService = authorizeService;
	}

	@PostMapping("/{userId}")
	public ResponseEntity<FieldCreateResponse> createField(
		@RequestHeader("Authorization") String token,
		@RequestBody FieldCreateRequest fieldCreateRequest,
		@PathVariable Long uid) {
		// **생략**auth check
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			// **인증 후의 과정
			try {
				Field field = fieldService.createField(fieldCreateRequest, userId);
				FieldCreateResponse fieldCreateResponse = FieldCreateResponse.builder()
					.id(field.getId())
					.name(field.getName())
					.createdAt(field.getCreatedAt())
					.build();
				return ResponseEntity.ok(fieldCreateResponse);
			} catch (FieldNotCreatedException e) {
				log.info(e.getMessage());
				return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@GetMapping("/{userId}")
	public ResponseEntity<List<FieldReadResponse>> readAllFields(
		@RequestHeader("Authorization") String token,
		@PathVariable Long uid) {
		// **생략**auth check
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			// **인증 후의 과정
			try {
				List<Field> fields = fieldService.readAllFields(userId);
				List<FieldReadResponse> fieldReadResponses = new ArrayList<>();
				for (Field field : fields) {
					FieldReadResponse fieldReadResponse = FieldReadResponse.builder()
						.id(field.getId())
						.name(field.getName())
						.createdAt(field.getCreatedAt())
						.build();
					fieldReadResponses.add(fieldReadResponse);
				}
				return ResponseEntity.ok(fieldReadResponses);
			} catch (FieldAllNotFoundException e) {
				log.info(e.getMessage());
				return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@GetMapping("/{userId}/{fieldId}")
	public ResponseEntity<List<OnionOutlineDto>> readFieldOnions(
		@RequestHeader("Authorization") String token,
		@PathVariable Long fieldId) {
		// **생략**auth check
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			// **인증 후의 과정
			try {
				List<Onion> onionList = fieldService.findOnionListByFieldId(fieldId);
				List<OnionOutlineDto> resultList = onionList.stream()
					.map(e -> OnionOutlineDto.from(e, fieldService.getNameByUserId(e.getUserId())))
					.collect(Collectors.toList());

				return ResponseEntity.ok(resultList);
			} catch (FieldNotFoundException e) {
				log.info(e.getMessage());
				return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@PutMapping("/{userId}/{fieldId}")
	public ResponseEntity<FieldReadResponse> updateField(
		@RequestHeader("Authorization") String token,
		@RequestBody FieldUpdateRequest fieldUpdateRequest,
		@PathVariable Long fieldId) {
		// **생략**auth check
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			// **인증 후의 과정
			try {
				Field field = fieldService.updateField(fieldId, fieldUpdateRequest.getName());
				FieldReadResponse fieldReadResponse = FieldReadResponse.builder()
					.id(field.getId())
					.name(field.getName())
					.createdAt((field.getCreatedAt()))
					.build();
				return ResponseEntity.ok(fieldReadResponse);
			} catch (FieldNotUpdatedException e) {
				log.info(e.getMessage());
				return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@DeleteMapping("/{userId}/{fieldId}")
	public ResponseEntity<Boolean> deleteField(
		@RequestHeader("Authorization") String token,
		@PathVariable Long fieldId) {
		// **생략**auth check
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			// **인증 후의 과정
			try {
				fieldService.deleteField(fieldId);
				return ResponseEntity.ok().build();
			} catch (FieldNotDeletedException e) {
				log.info(e.getMessage());
				return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}
}
