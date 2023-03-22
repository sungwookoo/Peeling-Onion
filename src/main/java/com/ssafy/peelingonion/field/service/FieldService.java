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
}
