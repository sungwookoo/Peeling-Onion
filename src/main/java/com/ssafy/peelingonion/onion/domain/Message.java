package com.ssafy.peelingonion.onion.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.ssafy.peelingonion.onion.controller.dto.MessageCreateRequest;
import com.ssafy.peelingonion.record.domain.Record;
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
@Table(name = "message")
public class Message {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id", nullable = false)
	private Long userId;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "content", length = 1000)
	private String content;

	@Column(name = "pos_rate")
	private Double posRate;

	@Column(name = "neg_rate")
	private Double negRate;

	@NotNull
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "record_id")
	private Record record;

	@NotNull
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "onion_id")
	private Onion onion;

	public static Message from(Long userId, Onion oni, Record record, MessageCreateRequest messageCreateRequest) {
		return Message.builder()
				.userId(userId)
				.onion(oni)
				.record(record)
				.createdAt(Instant.now())
				.content(messageCreateRequest.getContent())
				.posRate(messageCreateRequest.getPos_rate())
				.negRate(messageCreateRequest.getNeg_rate())
				.build();
	}
}