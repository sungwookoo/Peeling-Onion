package com.ssafy.peelingonion.onion.domain;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.peelingonion.common.StringToInstant;
import com.ssafy.peelingonion.field.domain.Storage;

import com.ssafy.peelingonion.onion.controller.dto.OnionCreateRequest;
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
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "onion_name", length = 50)
	private String name;

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

	@Column(name = "is_single")
	private Boolean isSingle;

	@OneToMany(mappedBy = "onion")
	@ToString.Exclude
	@Builder.Default
	private Set<Storage> storages = new LinkedHashSet<>();

	@OneToMany(mappedBy = "onion")
	@ToString.Exclude
	@Builder.Default
	private Set<Message> messages = new LinkedHashSet<>();

	@OneToMany(mappedBy = "onion")
	@ToString.Exclude
	@Builder.Default
	private Set<ReceiveOnion> receiveOnions = new LinkedHashSet<>();

	@OneToMany(mappedBy = "onion")
	@ToString.Exclude
	@Builder.Default
	private Set<SendOnion> sendOnions = new LinkedHashSet<>();

	public static Onion from(OnionCreateRequest onionCreateRequest, Long userId) {
		Instant inst = StringToInstant.S2Ins(onionCreateRequest.getGrow_due_date());
		return Onion.builder()
				.name(onionCreateRequest.getName())
				.imgSrc(onionCreateRequest.getImg_src())
				.userId(userId)
				.createdAt(Instant.now())
				.latestModify(Instant.now())
				.growDueDate(inst)
				.isDisabled(Boolean.FALSE)
				.isSingle(onionCreateRequest.getIs_single())
				.build();
	}
}