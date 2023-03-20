package com.ssafy.peelingonion.record.domain;

import java.time.Instant;
import java.util.LinkedHashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ssafy.peelingonion.onion.domain.Message;

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
@Table(name = "recorded_voice")
public class RecordedVoice {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "user_id")
	private Long userId;

	@Column(name = "created_at")
	private Instant createdAt;

	// S3에 저장된 주소를 저장한다.
	@Column(name = "file_src", length = 200)
	private String fileSrc;

	@OneToMany(mappedBy = "recordedVoice")
	private Set<Message> messages = new LinkedHashSet<>();

}