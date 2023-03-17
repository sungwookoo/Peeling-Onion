package com.ssafy.peelingonion.user.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "blocked")
public class Blocked {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id", nullable = false)
	private Long userId;

	@Column(name = "target_id", nullable = false)
	private Long targetId;

	@Column(name = "created_at")
	private Instant createdAt;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public Long getTargetId() {
		return targetId;
	}

	public void setTargetId(Long targetId) {
		this.targetId = targetId;
	}

	public Instant getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Instant createdAt) {
		this.createdAt = createdAt;
	}

}