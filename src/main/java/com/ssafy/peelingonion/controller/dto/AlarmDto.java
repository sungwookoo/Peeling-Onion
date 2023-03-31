package com.ssafy.peelingonion.controller.dto;

import com.ssafy.peelingonion.domain.Alarm;
import com.ssafy.peelingonion.service.AlarmService;

import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
@Builder
@ToString
public class AlarmDto {
	public Long sender_id;
	public Long receiver_id;
	public Integer type;
	public String sender_img_src;
	public String receiver_img_src;
	public Long message_id;
	public Boolean is_read;

	public static AlarmDto from(Alarm alarm) {
		return AlarmDto.builder()
			.sender_id(alarm.getSenderId())
			.receiver_id(alarm.getReceiverId())
			.type(alarm.getType())
			.is_read(alarm.getIsRead())
			.message_id(alarm.getId())
			.build();
	}

	public static AlarmDto from(Alarm e, AlarmService alarmService) {
		AlarmDto alarmDto = AlarmDto.from(e);
		alarmDto.receiver_img_src = alarmService.getUserImgSrc(e.getReceiverId());
		alarmDto.sender_img_src = alarmService.getUserImgSrc(e.getSenderId());
		return alarmDto;
	}
}

