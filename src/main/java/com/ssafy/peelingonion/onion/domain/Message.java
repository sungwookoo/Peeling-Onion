package com.ssafy.peelingonion.onion.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.ssafy.peelingonion.record.domain.RecordedVoice;

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
// 양파 한겹
public class Message {
	@Id
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

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "onion_id", nullable = false)
	private Onion onion;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "record_id", nullable = false)
	private RecordedVoice recordedVoice;

}