package com.ssafy.peelingonion.user.service;

import static com.ssafy.peelingonion.common.ConstValues.*;

import java.util.List;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ssafy.peelingonion.user.controller.dto.FieldCreateRequest;
import com.ssafy.peelingonion.user.domain.User;
import com.ssafy.peelingonion.user.domain.UserRepository;
import com.ssafy.peelingonion.user.service.exceptions.UserNotFoundException;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

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
		if (null != des.getNickname())
			src.setNickname(des.getNickname());
		if (null != des.getMobileNumber())
			src.setMobileNumber(des.getMobileNumber());
		if (null != des.getImgSrc())
			src.setImgSrc(des.getImgSrc());
		userRepository.save(src);
	}

	public Long enrollUser(User user, String token) {
		Optional<User> optUser = userRepository.findById(user.getId());
		// 이미 회원인경우,
		if (optUser.isPresent()) {
			return optUser.get().getId();
		} else { // 비회원인경우
			Optional<User> isUnActiveUser = userRepository.findByKakaoId(user.getKakaoId());
			if (isUnActiveUser.isPresent()) { // 비활성 유저였다면
				User unActiveUser = isUnActiveUser.get();
				unActiveUser.setActivate(true);
				unActiveUser.setNickname(user.getNickname());
				unActiveUser.setMobileNumber(user.getMobileNumber());
				unActiveUser.setImgSrc(user.getImgSrc());
				userRepository.save(unActiveUser);
				return unActiveUser.getId();
			} else { // 신규유저
				user.setId(null); // autoincrement를 활용하기 위해 null 처리
				User newUser = userRepository.save(user);
				try {
					BIZ_SERVER_CLIENT.post()
						.uri(CREATE_FILED_URI)
						.header("Authorization", token)
						.bodyValue(FieldCreateRequest.builder()
							.name("기본")
							.build())
						.retrieve()
						.onStatus(HttpStatus::is4xxClientError, clientResponse -> Mono.error(RuntimeException::new))
						.onStatus(HttpStatus::is5xxServerError, clientResponse -> Mono.error(RuntimeException::new))
						.bodyToMono(Void.class)
						.block();
				} catch (Exception e) {
					log.error("{}",e.getMessage());
				}
				return newUser.getId();
			}
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

	public Long getUserId(String mobileNumber) {
		Optional<User> optUser = userRepository.findByMobileNumber(mobileNumber);
		if (optUser.isPresent()) {
			return optUser.get().getId();
		} else
			return -1L;
	}
}
