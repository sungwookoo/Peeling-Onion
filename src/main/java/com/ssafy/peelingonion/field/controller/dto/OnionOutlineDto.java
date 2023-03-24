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
	public String onion_name;
	public String img_src;
	public Instant receive_date; // 받은 날짜
	public String sender; // 대표 발신자
	public Boolean is_single; // True : 혼자보내는 것, False : 모아보내는 것

	/**
	 * 생성자 이름이 지정되지 않음.
	 * 별도로 지정이 필요함.
	 * @param onion
	 * @return
	 */
	public static OnionOutlineDto from(Onion onion) {
		return OnionOutlineDto.builder()
			.id(onion.getId())
			.onion_name(onion.getName())
			.img_src(onion.getImgSrc())
			.receive_date(onion.getSendDate())
			.is_single(onion.getIsSingle())
			.build();
	}

	public static OnionOutlineDto from(Onion onion, String name) {
		return OnionOutlineDto.builder()
			.id(onion.getId())
			.onion_name(onion.getName())
			.img_src(onion.getImgSrc())
			.receive_date(onion.getSendDate())
			.sender(name)
			.is_single(onion.getIsSingle())
			.build();
	}
}
