package com.ssafy.peelingonion.onion.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
import com.sun.istack.NotNull;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Entity
@Table(name = "send_onion")
public class SendOnion {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id", nullable = false)
	private Long userId;

	@Column(name = "receiver_number", length = 11)
	private String receiverNumber;

	@Column(name = "is_sended")
	private Boolean isSended;

	@NotNull
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "onion_id")
	private Onion onion;

	public static SendOnion from(Long senderId, OnionCreateRequest onionCreateRequest, Onion newOnion) {
		return SendOnion.builder()
				.userId(senderId)
				.receiverNumber(onionCreateRequest.getReceiver_number())
				.isSended(Boolean.FALSE)
				.onion(newOnion)
				.build();
	}
}