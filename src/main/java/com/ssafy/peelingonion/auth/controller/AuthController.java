package com.ssafy.peelingonion.auth.controller;

import static com.ssafy.peelingonion.common.ConstValues.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.auth.service.AuthService;
import com.ssafy.peelingonion.auth.service.exceptions.KakaoError;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/auth")
public class AuthController {
	private final AuthService authService;

	@Autowired
	public AuthController(AuthService authService) {
		this.authService = authService;
	}

	@GetMapping("/validity/kakao")
	public ResponseEntity<Long> validateCheck(@RequestHeader("Authorization") String token) {
		try {
			final Long kakaoId = authService.validateCodeOnKakao(token);
			if (kakaoId.equals(UNAUTHRIZED))
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
			return ResponseEntity.ok(authService.findUserId(kakaoId));
		} catch (KakaoError e) {
			log.error(e.getMessage());
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}
	}
}
