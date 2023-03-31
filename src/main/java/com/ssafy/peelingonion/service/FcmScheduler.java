package com.ssafy.peelingonion.service;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.ssafy.peelingonion.domain.Alarm;
import com.ssafy.peelingonion.domain.AlarmRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FcmScheduler {
	private final AlarmRepository alarmRepository;
	private final AlarmService alarmService;

	@Autowired
	public FcmScheduler(AlarmRepository alarmRepository, AlarmService alarmService) {
		this.alarmRepository = alarmRepository;
		this.alarmService = alarmService;
	}

	@Async
	@Scheduled(fixedRate = 1000 * 60 * 60 * 60) // execute every 1 hour
	public void sendFcmMessage() {
		try {
			List<Alarm> notSendedAlarmList = alarmRepository.findByIsSended(false);
			for (Alarm alarm : notSendedAlarmList) {
				if(alarmService.getNameByUserId(alarm.getReceiverId()).equals(""))
					continue;

				alarmService.sendMessageTo(alarm); // fcm server에 전송
				alarm.setIsSended(true); // 보냄처리
				alarmRepository.save(alarm); // DB에 반영
			}
		} catch (IOException e) {
			log.info("{}", e.getMessage());
		}
	}
}