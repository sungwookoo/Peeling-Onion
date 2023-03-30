package com.ssafy.peelingonion.controller.dto;

import java.time.Instant;

import com.ssafy.peelingonion.common.ConstValues;
import com.ssafy.peelingonion.domain.Alarm;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AlarmRequest {
	private final Long sender_id;
	private final Long receiver_id;
	private final String content;
	private final Instant created_at;
	private final Integer type;

	public static Alarm to(AlarmRequest alarmRequest) {
		return Alarm.builder()
			.senderId(alarmRequest.sender_id)
			.receiverId(alarmRequest.receiver_id)
			.content(alarmRequest.content)
			.createdAt(alarmRequest.created_at)
			.type(alarmRequest.type)
			.isSended(false)
			.build();
	}
}
