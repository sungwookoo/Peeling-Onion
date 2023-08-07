package com.ssafy.peelingonion.auth.domain;

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
@Table(name = "user")
public class User {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "kakao_id")
	private Long kakaoId;

	@Column(name = "nickname", length = 20)
	private String nickname;

	@Column(name = "img_src", length = 200)
	private String imgSrc;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "activate")
	private Boolean activate;

	@Column(name = "mobile_number", length = 11)
	private String mobileNumber;

	@OneToMany(mappedBy = "user")
	@ToString.Exclude
	@Builder.Default
	private Set<Withdraw> withdraws = new LinkedHashSet<>();

	@OneToMany(mappedBy = "user")
	@ToString.Exclude
	@Builder.Default
	private Set<Auth> auths = new LinkedHashSet<>();

	@OneToMany(mappedBy = "user")
	@ToString.Exclude
	@Builder.Default
	private Set<Report> reportUser = new LinkedHashSet<>();

	@OneToMany(mappedBy = "targetUserId")
	@ToString.Exclude
	@Builder.Default
	private Set<Report> reportTargets = new LinkedHashSet<>();
}