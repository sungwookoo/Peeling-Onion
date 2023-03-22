package com.ssafy.peelingonion.field.domain;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
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
@Table(name = "field")
public class Field {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "name", length = 30)
	private String name;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "is_disabled")
	private Boolean isDisabled;

	@OneToMany(mappedBy = "field")
	@ToString.Exclude
	@Builder.Default
	private Set<Storage> storages = new LinkedHashSet<>();

	@OneToMany(mappedBy = "field")
	@ToString.Exclude
	@Builder.Default
	private Set<MyField> myFields = new LinkedHashSet<>();

}