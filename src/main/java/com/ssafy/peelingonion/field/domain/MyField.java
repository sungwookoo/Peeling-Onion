package com.ssafy.peelingonion.field.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

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
@Table(name = "my_field")
public class MyField {
	@Id
	@Column(name = "uid", nullable = false)
	private Long uid;

	@Column(name = "user_id", nullable = false)
	private Long userId;

	@NotNull
	@ManyToOne
	@JoinColumn(name = "field_id")
	private Field field;

}