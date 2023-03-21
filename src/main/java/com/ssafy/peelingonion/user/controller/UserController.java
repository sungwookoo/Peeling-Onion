package com.ssafy.peelingonion.user.controller;

import static com.ssafy.peelingonion.common.security.ConstValue.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.ssafy.peelingonion.user.controller.dto.UserProfileRequestDto;
import com.ssafy.peelingonion.user.controller.dto.UserProfileResponseDto;
import com.ssafy.peelingonion.user.controller.dto.UserResponseDto;
import com.ssafy.peelingonion.user.service.UserService;
import com.ssafy.peelingonion.user.service.exceptions.UserNotFoundException;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
@RequestMapping("/${apiPrefix}/user")
public class UserController {
	private final UserService userService;

	@Autowired
	public UserController(UserService userService) {
		this.userService = userService;
	}

	@GetMapping("/{userId}")
	public ResponseEntity<UserResponseDto> searchUserInformation(@PathVariable Long userId) {
		// 토큰에 관한 인증이 완료된 상태
		//final String uri = SERVICE_URI + "/user/" + userId.toString();
		final String uri = "https://stoplight.io/mocks/ggaggayang/peelingonion/149504280/user/1";
		log.debug("test output : " + uri);

		try {
			UserResponseDto userResponseDto = userService.getUserClient()
				.get()
				.uri(uri)
				.retrieve()
				.bodyToMono(UserResponseDto.class)
				.onErrorResume(error -> {
					if (error instanceof WebClientResponseException.NotFound) {
						return Mono.error(new UserNotFoundException("User not found"));
					} else {
						return Mono.error(error);
					}
				})
				.block();
			return ResponseEntity.ok(userResponseDto);
		} catch (UserNotFoundException e) {
			return ResponseEntity.noContent().build();
		}
	}

	@PostMapping("/{userId}")
	public ResponseEntity<String> enrollUserInformation(@PathVariable Long userId) {

		return ResponseEntity.ok().build();
	}

	@PatchMapping("/{userId}")
	public ResponseEntity<UserProfileResponseDto> modifyUserInformation(
		@RequestBody UserProfileRequestDto userProfileRequestDto) {
		// 토큰에 관한 인증이 완료된 상태
		//final String uri = SERVICE_URI + "/user/" + userId.toString();
		final String uri = "https://stoplight.io/mocks/ggaggayang/peelingonion/149504280/user/1";
		log.debug("test output : " + uri);

		try {
			UserProfileResponseDto userProfileResponseDto = userService.getUserClient()
				.patch()
				.uri(uri)
				.body(Mono.just(userProfileRequestDto),UserProfileRequestDto.class) // 요청
				.retrieve() // 응답 해석
				.bodyToMono(UserProfileResponseDto.class) // 응답을 Mono로
				.onErrorResume(error -> {
					if (error instanceof WebClientResponseException.NotFound) {
						return Mono.error(new UserNotFoundException("User not found"));
					} else {
						return Mono.error(error);
					}
				})
				.block(); // Thread 중지
			return ResponseEntity.ok(userProfileResponseDto);
		} catch (UserNotFoundException e) {
			return ResponseEntity.noContent().build();
		}
	}

	@DeleteMapping("/{userId}")
	public ResponseEntity<String> removeUserInformation(@PathVariable Long userId) {
		return ResponseEntity.ok().build();
	}
}
