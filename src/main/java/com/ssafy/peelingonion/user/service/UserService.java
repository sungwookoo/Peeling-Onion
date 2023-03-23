package com.ssafy.peelingonion.user.service;

import java.util.List;

import org.springframework.stereotype.Service;

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

	public void modifyUser(User src, User des) {
		if (null != src.getNickname())
			des.setNickname(src.getNickname());
		if (null != src.getMobileNumber())
			des.setMobileNumber(src.getMobileNumber());
		if (null != src.getImgSrc())
			des.setImgSrc(src.getImgSrc());
		userRepository.save(des);
	}

	public Long enrollUser(User user) {
		// 이미 회원인경우,
		if (userRepository.existsById(user.getId())) {
			User base = userRepository.findById(user.getId()).get();
			if (!base.getActivate().equals(true)) {
				// 비활성 유저인경우
				base.setActivate(true);
				userRepository.save(base);
			}

			return base.getId();
		} else { // 신규 가입자인 경우
			User newUser = userRepository.save(user);
			return newUser.getId();
		}
	}

	public void removeUser(Long userId) {
		User user = userRepository.findById(userId)
			.orElseThrow(UserNotFoundException::new);
		user.setActivate(false);
		userRepository.save(user);
	}

	public List<User> searchData(String keyword, Long userId) {
		User user = userRepository.findById(userId).orElse(User.builder().nickname("").build());
		return userRepository.findTop10ByNicknameContainsAndNicknameNotLike(keyword, user.getNickname());
	}
}
