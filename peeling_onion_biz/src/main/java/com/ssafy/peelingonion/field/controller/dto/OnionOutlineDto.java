package com.ssafy.peelingonion.field.controller.dto;

import com.ssafy.peelingonion.onion.domain.ReceiveOnion;
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

	public static OnionOutlineDto from(ReceiveOnion receiveOnion, String name) {
		Onion o = receiveOnion.getOnion();
		return OnionOutlineDto.builder()
				.id(o.getId())
				.onion_name(o.getName())
				.img_src(o.getImgSrc())
				.receive_date(o.getSendDate())
				.sender(name)
				.is_single(o.getIsSingle())
				.build();
	}
}
