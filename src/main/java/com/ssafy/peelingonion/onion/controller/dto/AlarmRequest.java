package com.ssafy.peelingonion.onion.controller.dto;

import java.time.Instant;

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
}
