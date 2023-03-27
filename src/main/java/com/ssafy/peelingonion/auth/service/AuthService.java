package com.ssafy.peelingonion.auth.service;

import static com.ssafy.peelingonion.common.ConstValues.*;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import com.ssafy.peelingonion.auth.controller.KakaoDto;
import com.ssafy.peelingonion.auth.domain.User;
import com.ssafy.peelingonion.auth.domain.UserRepository;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Service
@Slf4j
public class AuthService {
	private final UserRepository userRepository;
	private final WebClient client;

	public AuthService(UserRepository userRepository) {
		this.client = WebClient.builder().baseUrl(KAKAO_URI).build();
		this.userRepository = userRepository;
	}

	public Long validateCodeOnKakao(String token) {
		boolean flag = false;

		KakaoDto kakaoDto = KakaoDto.builder().id(-1L).build();
		try {
			kakaoDto = client.get()
				.uri(KAKAO_URI)
				.header("Authorization", token)
				.retrieve()
				.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
				.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
				.bodyToMono(KakaoDto.class)
				.block();
		} catch (Exception e) {
			log.error(e.getMessage());
		}
		return kakaoDto.getId();
	}

	public Long findUserId(Long kakaoId) {
		return userRepository.findByKakaoId(kakaoId).orElse(User.builder().id(NON_MEMBER).build()).getId();
	}
}
