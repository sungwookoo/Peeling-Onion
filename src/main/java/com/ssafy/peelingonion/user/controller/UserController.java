package com.ssafy.peelingonion.user.controller;

import static com.ssafy.peelingonion.common.ConstValues.*;

import java.time.Duration;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.common.service.AuthorizeService;
import com.ssafy.peelingonion.user.controller.dto.SearchUserResponseDto;
import com.ssafy.peelingonion.user.controller.dto.UserExitstInfoDto;
import com.ssafy.peelingonion.user.controller.dto.UserRequestDto;
import com.ssafy.peelingonion.user.controller.dto.UserResponseDto;
import com.ssafy.peelingonion.user.domain.User;
import com.ssafy.peelingonion.user.service.UserService;
import com.ssafy.peelingonion.user.service.exceptions.UserNotFoundException;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {
	private final UserService userService;
	private final AuthorizeService authorizeService;
	private final RedisTemplate<Long, String> redisTemplate;

	@Autowired
	public UserController(UserService userService, AuthorizeService authorizeService,
		RedisTemplate<Long, String> redisTemplate) {
		this.userService = userService;
		this.authorizeService = authorizeService;
		this.redisTemplate = redisTemplate;
	}

	@GetMapping("")
	public ResponseEntity<UserExitstInfoDto> isMember(@RequestHeader("Authorization") String token) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId))
			return ResponseEntity.ok(UserExitstInfoDto.from(userId));
		else
			return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
	}

	@GetMapping("/{userId}")
	public ResponseEntity<UserResponseDto> searchUserInfomation(@RequestHeader("Authorization") String token,
		@PathVariable Long userId) {
		try {
			UserResponseDto userResponseDto = UserResponseDto.from(userService.getUserInfomation(userId));
			return ResponseEntity.ok(userResponseDto);
		} catch (UserNotFoundException e) {
			return ResponseEntity.noContent().build();
		}
	}

	@PostMapping("")
	public ResponseEntity<UserExitstInfoDto> enrollUserInfomation(@RequestHeader("Authorization") String token,
		@RequestBody UserRequestDto userRequestDto) {
		final Long userId = authorizeService.getAuthorization(token);
		log.info("token :" + token);
		// 토큰이 유효하지 않음
		if (userId.equals(UNAUTHORIZED_USER)) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}
		return ResponseEntity.ok(UserExitstInfoDto.from(userService.enrollUser(UserRequestDto.to(userRequestDto, userId), token)));
	}

	@PatchMapping("")
	public ResponseEntity<String> modifyUserInfomation(@RequestHeader("Authorization") String token,
		@RequestBody UserRequestDto userRequestDto) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			try {
				User baseUser = userService.getUserInfomation(userId);
				userService.modifyUser(baseUser, UserRequestDto.to(userRequestDto));
			} catch (UserNotFoundException e) {
				log.error(e.getMessage());
			}
		}
		return ResponseEntity.ok().build();
	}

	@DeleteMapping("")
	public ResponseEntity<String> removeUserInfomation(@RequestHeader("Authorization") String token) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			try {
				userService.removeUser(userId);
			} catch (UserNotFoundException e) {
				log.error(e.getMessage());
			}
			return ResponseEntity.ok().build();
		}
		return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
	}

	@GetMapping("/nickname/duplicate/{nickname}")
	public ResponseEntity<Boolean> duplicateCheck(@PathVariable String nickname) {
		final boolean isExist = userService.isDuplicate(nickname);
		return ResponseEntity.ok(isExist);
	}

	@GetMapping("/nickname/{keyword}")
	public ResponseEntity<List<SearchUserResponseDto>> searchCheck(@RequestHeader("Authorization") String token,
		@PathVariable String keyword) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			List<SearchUserResponseDto> list = userService.searchData(keyword, userId)
				.stream()
				.map(SearchUserResponseDto::from)
				.collect(Collectors.toList());

			return ResponseEntity.ok(list);
		}

		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	@GetMapping("/{userId}/nickname")
	public ResponseEntity<String> getNickname(@PathVariable Long userId) {
		try {
			User user = userService.getUserInfomation(userId);
			return ResponseEntity.ok(user.getNickname());
		} catch (UserNotFoundException e) {
			return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
		}
	}

	@GetMapping("/{userId}/mobile")
	public ResponseEntity<String> getMobileNumber(@PathVariable Long userId) {
		try {
			User user = userService.getUserInfomation(userId);
			return ResponseEntity.ok(user.getMobileNumber());
		} catch (UserNotFoundException e) {
			return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
		}
	}

	@GetMapping("/mobile/{mobileNumber}")
	public ResponseEntity<Long> getUserId(@PathVariable String mobileNumber) {
		try {
			return ResponseEntity.ok(userService.getUserId(mobileNumber));
		} catch (UserNotFoundException e) {
			return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
		}
	}

	@GetMapping("/fcm/{userId}")
	public ResponseEntity<String> getUserFCMToken(@PathVariable Long userId) {
		String requestToken = redisTemplate.opsForValue().get(userId);
		if (null == requestToken) {
			requestToken = "";
		}
		return ResponseEntity.ok(requestToken);
	}

	@PostMapping("/fcm/{fcm}")
	public ResponseEntity<String> setUserFCMToken(@RequestHeader("Authorization") String token,
		@PathVariable String fcm) {
		final Long userId = authorizeService.getAuthorization(token);
		if (authorizeService.isAuthorization(userId)) {
			Duration expirationTime = Duration.ofDays(7); // 7일까지만 저장
			redisTemplate.opsForValue().set(userId, fcm, expirationTime);
			return ResponseEntity.ok("OK");
		}
		return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	}

	// Gateway Test
	@GetMapping("/gateway")
	public ResponseEntity<String> test() {
		return ResponseEntity.ok("main Branch");
	}
}
