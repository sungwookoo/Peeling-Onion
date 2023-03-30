package com.ssafy.peelingonion.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.controller.dto.AlarmRequest;
import com.ssafy.peelingonion.controller.dto.RequestDTO;
import com.ssafy.peelingonion.service.AlarmService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/alarm")
public class AlarmController {

	private final AlarmService alarmService;

	@Autowired
	public AlarmController(AlarmService alarmService) {
		this.alarmService = alarmService;
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
			requestDTO.getBody());
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
}