package com.ssafy.peelingonion.user.service;

import org.springframework.stereotype.Service;

import com.ssafy.peelingonion.user.controller.dto.UserRequestDto;
import com.ssafy.peelingonion.user.domain.User;
import com.ssafy.peelingonion.user.domain.UserRepository;
import com.ssafy.peelingonion.user.service.exceptions.UserNotFoundException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserService {
	private final UserRepository userRepository;

	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	public boolean isDuplicate(String nickname) {
		return userRepository.existsByNickname(nickname);
	}

	public User getUserInfomation(Long userId) {
		return userRepository.findById(userId)
			.orElseThrow(UserNotFoundException::new);
	}

	public void modifyUser(UserRequestDto userRequestDto) {

	}
}
