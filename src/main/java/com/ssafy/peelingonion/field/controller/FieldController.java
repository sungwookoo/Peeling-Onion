package com.ssafy.peelingonion.field.controller;

import com.ssafy.peelingonion.field.controller.dto.FieldCreateRequestDto;
import com.ssafy.peelingonion.field.controller.dto.FieldCreateResponseDto;
import com.ssafy.peelingonion.field.controller.dto.FieldReadResponseDto;
import com.ssafy.peelingonion.field.domain.Field;
import com.ssafy.peelingonion.field.service.FieldService;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/v1/field")
public class FieldController {
	private final FieldService fieldService;

	@Autowired
	public FieldController(FieldService fieldService) {
		this.fieldService = fieldService;
	}

	/**
	 * Create Field
	 * @param fieldCreateRequestDto
	 * @return FieldCreateResponseDto
	 */
	@PostMapping("/{user_id}")
	public ResponseEntity<FieldCreateResponseDto> createField(
		@RequestBody FieldCreateRequestDto fieldCreateRequestDto) {
		return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
	}

	//    @DeleteMapping("/{user_id}")
	//    public void deleteField(
	//            @
	//    )

	// 유저의 모든 필드 정보를 가져옴 - 해당 밭에 있는 양파의 요약정보까지 가져와야한다.(썪음 여부까지)
	@GetMapping("/{user_id}")
	public ResponseEntity<List<FieldReadResponseDto>> readFields(
		@PathVariable Long userId) {
		return ResponseEntity.status(HttpStatus.NO_CONTENT).build();

	}

}
