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
@Table(name = "record")
public class Record {
	@Id
	@Column(name = "id", nullable = false)
	private Long id;

	@Column(name = "created_at")
	private Instant createdAt;

	@Column(name = "file_src", length = 100)
	private String fileSrc;

	@OneToMany(mappedBy = "record")
	@ToString.Exclude
	@Builder.Default
	private Set<Message> messages = new LinkedHashSet<>();

	@OneToMany(mappedBy = "record")
	@ToString.Exclude
	@Builder.Default
	private Set<MyRecord> myRecords = new LinkedHashSet<>();

}