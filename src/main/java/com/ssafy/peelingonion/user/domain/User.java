package com.ssafy.peelingonion.user.domain;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.peelingonion.auth.domain.Auth;

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
@Table(name = "user")
public class User {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "kakao_id", length = 50)
	private String kakaoId;

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
	private Set<Withdraw> withdraws = new LinkedHashSet<>();

	@OneToMany(mappedBy = "user")
	private Set<Auth> auths = new LinkedHashSet<>();

	@OneToMany(mappedBy = "user")
	private Set<Report> reportUser = new LinkedHashSet<>();

	@OneToMany(mappedBy = "targetUserId")
	private Set<Report> reportTargets = new LinkedHashSet<>();

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(String kakaoId) {
		this.kakaoId = kakaoId;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getImgSrc() {
		return imgSrc;
	}

	public void setImgSrc(String imgSrc) {
		this.imgSrc = imgSrc;
	}

	public Instant getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Instant createdAt) {
		this.createdAt = createdAt;
	}

	public Boolean getActivate() {
		return activate;
	}

	public void setActivate(Boolean activate) {
		this.activate = activate;
	}

	public String getMobileNumber() {
		return mobileNumber;
	}

	public void setMobileNumber(String mobileNumber) {
		this.mobileNumber = mobileNumber;
	}

	public Set<Withdraw> getWithdraws() {
		return withdraws;
	}

	public void setWithdraws(Set<Withdraw> withdraws) {
		this.withdraws = withdraws;
	}

	public Set<Auth> getAuths() {
		return auths;
	}

	public void setAuths(Set<Auth> auths) {
		this.auths = auths;
	}

	public Set<Report> getReportUser() {
		return reportUser;
	}

	public void setReportUser(Set<Report> reportUser) {
		this.reportUser = reportUser;
	}

	public Set<Report> getReportTargets() {
		return reportTargets;
	}

	public void setReportTargets(Set<Report> reportTargets) {
		this.reportTargets = reportTargets;
	}

}