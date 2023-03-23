package com.ssafy.peelingonion.user.domain;

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
@Table(name = "notify_type")
public class NotifyType {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "type", length = 50)
	private String type;

	@Column(name = "value")
	private Integer value;
}