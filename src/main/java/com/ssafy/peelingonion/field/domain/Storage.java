package com.ssafy.peelingonion.field.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.ssafy.peelingonion.onion.domain.Onion;

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
@Table(name = "storage")
public class Storage {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id", nullable = false)
	private Long userId;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "is_bookmarked")
	private Boolean isBookmarked;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "field_id", nullable = false)
	private Field field;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "onion_id", nullable = false)
	private Onion onion;

}