package com.ssafy.peelingonion.onion.domain;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.peelingonion.field.domain.Storage;

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
@Table(name = "onion")
public class Onion {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "onion_name", length = 50)
	private String onionName;

	@Column(name = "mobile_number", length = 11)
	private String mobileNumber;

	@Column(name = "img_src", length = 200)
	private String imgSrc;

	@Column(name = "user_id")
	private Long userId;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "latest_modify")
	private Instant latestModify;

	@Column(name = "send_date")
	private Instant sendDate;

	@Column(name = "grow_due_date")
	private Instant growDueDate;

	@Column(name = "is_disabled")
	private Boolean isDisabled;

	@OneToMany(mappedBy = "onion")
	private Set<MyOnion> myOnions = new LinkedHashSet<>();

	@OneToMany(mappedBy = "onion")
	private Set<Storage> storages = new LinkedHashSet<>();

	@OneToMany(mappedBy = "onion")
	private Set<Message> messages = new LinkedHashSet<>();

}