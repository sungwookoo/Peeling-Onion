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
@Table(name = "receive_onion")
public class ReceiveOnion {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id", nullable = true)
	private Long userId;

	@Column(name = "from_user_id", nullable = false)
	private Long fromUserId;

	@Column(name = "is_received")
	private Boolean isReceived;		// 상대방이 보내면 True가 되어 택배함에서 확인할 수 있음

	@Column(name = "is_bookmarked")
	private Boolean isBookmarked;

	@Column(name = "receiver_number", length = 11)
	private String receiverNumber;	// 양파받은 사람 번호

	@Column(name = "is_checked")
	private Boolean isChecked;	// 택배함에서 읽으면 True값

	@NotNull
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "onion_id")
	private Onion onion;

	public static ReceiveOnion from(Onion onion, Long userId, OnionCreateRequest onionCreateRequest) {
		return ReceiveOnion.builder()
				.onion(onion)
				.fromUserId(userId)
				.isReceived(Boolean.FALSE)
				.isBookmarked(Boolean.FALSE)
				.receiverNumber(onionCreateRequest.getReceiver_number())
				.isChecked(Boolean.FALSE)
				.build();
	}
}