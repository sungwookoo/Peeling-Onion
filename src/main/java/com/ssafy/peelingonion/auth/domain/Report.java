package com.ssafy.peelingonion.auth.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Entity
@Table(name = "report")
public class Report {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "target_id", nullable = false)
	private Long targetId;

	@Column(name = "reason", length = 20)
	private String reason;

	@Column(name = "created_at")
	private Instant createdAt;

	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "user_id")
	private User user;

	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "target_user_id_id")
	private User targetUserId;
}