package com.ssafy.peelingonion.controller.dto;

import lombok.Data;
import lombok.Getter;
import lombok.ToString;

@Data
@Getter
@ToString
public class RequestDTO {
	private String token;
	private String title;
	private String body;
}
