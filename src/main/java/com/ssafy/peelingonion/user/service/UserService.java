package com.ssafy.peelingonion.user.service;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserService {
	private final WebClient webClient;

	public UserService() {
		this.webClient = WebClient.builder().baseUrl("${userServer}").build();
	}

	public WebClient getUserClient() {
		return webClient;
	}
}
