package com.ssafy.peelingonion.controller.dto;

import com.ssafy.peelingonion.domain.Alarm;

import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.ToString;

@Data
@Builder
public class AlarmDto {
	public Long sender_id;
	public Long receiver_id;
	public String content;
	public Integer type;

	public static AlarmDto from(Alarm alarm) {
		return AlarmDto.builder()
			.sender_id(alarm.getSenderId())
			.receiver_id(alarm.getReceiverId())
			.content(alarm.getContent())
			.type(alarm.getType())
			.build();
	}

	@Override
	public String toString() {
		return "{" +
			"\"sender_id\":\"" + "\"" + sender_id + "\"," +
			"\"receiver_id\":\"" + "\"" + receiver_id + "\"," +
			"\"content\":\"" + "\"" + content + "\"," +
			"\"type\":\"" + "\"" + type + "\"" +
			"}";
	}
}

