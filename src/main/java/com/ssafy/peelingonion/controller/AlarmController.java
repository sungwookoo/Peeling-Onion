package com.ssafy.peelingonion.controller;

import java.io.IOException;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.controller.dto.AlarmDto;
import com.ssafy.peelingonion.controller.dto.AlarmRequest;
import com.ssafy.peelingonion.controller.dto.RequestDTO;
import com.ssafy.peelingonion.service.AlarmService;
import com.ssafy.peelingonion.service.exceptions.AlarmNotFoundException;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/alarm")
public class AlarmController {

	private final AlarmService alarmService;
	private final AuthorizeService authorizeService;

	@Autowired
	public AlarmController(AlarmService alarmService, AuthorizeService authorizeService) {
		this.alarmService = alarmService;
		this.authorizeService = authorizeService;
	}

	/**
	 * push 서버 전송을 직접 요청 받는 경우.
	 * 즉시 Push 한다.
	 * @param requestDTO
	 * @return
	 * @throws IOException
	 */
	@PostMapping("/fcm")
	public ResponseEntity<String> pushMessage(@RequestBody RequestDTO requestDTO) throws IOException {
		log.info("{}", requestDTO.toString());
		alarmService.sendMessageTo(
			requestDTO.getToken(),
			requestDTO.getTitle(),
			requestDTO.getBody(),0);
		return ResponseEntity.ok().build();
	}

	/**
	 * Notification Server에 알림을 등록한다.
	 * 해당 서버에 등록된 알림은 주기적으로 Push 된다.
	 * @param alarmRequest
	 * @return
	 */
	@PostMapping("")
	public ResponseEntity<String> addNotificate(@RequestBody AlarmRequest alarmRequest) {
		alarmService.saveNotification(AlarmRequest.to(alarmRequest));
		return ResponseEntity.ok("OK");
	}

	@GetMapping("/list")
	public ResponseEntity<List<AlarmDto>> getAlarmsList(@RequestHeader("Authorization") String token) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			List<AlarmDto> list = alarmService.getAlarmList(userId)
				.stream()
				.map(e -> AlarmDto.from(e, alarmService))
				.collect(Collectors.toList());
			return ResponseEntity.ok(list);
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@PutMapping("/{alarmId}")
	public ResponseEntity<String> modifyReadState(@RequestHeader("Authorization") String token,
		@PathVariable Long alarmId) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			try {
				boolean flag = alarmService.readAlarm(userId, alarmId);
				if (flag)
					return ResponseEntity.ok("OK");
				return ResponseEntity.badRequest().build();
			} catch (AlarmNotFoundException e) {
				log.error("{}", e.getMessage());
			}
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}
}