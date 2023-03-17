package com.ssafy.peelingonion.auth.service;

import org.springframework.stereotype.Service;

import com.ssafy.peelingonion.auth.domain.AuthRepository;

@Service
public class AuthService {
	private final AuthRepository authRepository;

	public AuthService(AuthRepository authRepository) {
		this.authRepository = authRepository;
	}
}
