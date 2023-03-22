package com.ssafy.peelingonion.onion.domain;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

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
@Table(name = "onion_face")
public class OnionFace {
	@Id
	@Column(name = "uid", nullable = false)
	private Long uid;

	@Column(name = "onion_id", nullable = false)
	private Long onionId;

	@Column(name = "pos_rate")
	private Double posRate;

	@Column(name = "neg_rate")
	private Double negRate;

	@Column(name = "last_update")
	private Instant lastUpdate;

	@Column(name = "img_src", length = 50)
	private String imgSrc;

}