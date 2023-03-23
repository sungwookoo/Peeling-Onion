package com.ssafy.peelingonion.field.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

import com.ssafy.peelingonion.onion.domain.Onion;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OnionOutlineDto {
	public Long id;
	public String onionName;
	public String imgSrc;
	public Instant recieveDate; // 받은 날짜
	public String sender; // 대표 발신자
	public Boolean isSingle; // True : 혼자보내는 것, False : 모아보내는 것

	/**
	 * 생성자 이름이 지정되지 않음.
	 * 별도로 지정이 필요함.
	 * @param onion
	 * @return
	 */
	public static OnionOutlineDto from(Onion onion) {
		return OnionOutlineDto.builder()
			.id(onion.getId())
			.onionName(onion.getOnionName())
			.imgSrc(onion.getImgSrc())
			.recieveDate(onion.getSendDate())
			.isSingle(onion.getIsSingle())
			.build();
	}

	public static OnionOutlineDto from(Onion onion, String name) {
		return OnionOutlineDto.builder()
			.id(onion.getId())
			.onionName(onion.getOnionName())
			.imgSrc(onion.getImgSrc())
			.recieveDate(onion.getSendDate())
			.sender(name)
			.isSingle(onion.getIsSingle())
			.build();
	}
}
