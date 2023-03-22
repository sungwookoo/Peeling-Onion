package com.ssafy.peelingonion.user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.user.controller.dto.UserRequestDto;
import com.ssafy.peelingonion.user.controller.dto.UserResponseDto;
import com.ssafy.peelingonion.user.service.UserService;
import com.ssafy.peelingonion.user.service.exceptions.UserNotFoundException;

import lombok.extern.slf4j.Slf4j;

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
	public ResponseEntity<UserResponseDto> searchUserInfomation(@PathVariable Long userId) {
		try{
			UserResponseDto userResponseDto = UserResponseDto.from(userService.getUserInfomation(userId));
			return ResponseEntity.ok(userResponseDto);
		}catch (UserNotFoundException e){
			return ResponseEntity.noContent().build();
		}
	}

	@PostMapping("")
	public ResponseEntity<String> enrollUserInfomation(@RequestBody UserRequestDto userRequestDto) {
		//userService.e
		return ResponseEntity.ok().build();
	}

	@PatchMapping("")
	public ResponseEntity<String> modifyUserInfomation(@RequestBody UserRequestDto userRequestDto) {
		try{
			userService.modifyUser(userRequestDto);
		}catch (UserNotFoundException e){

		}
		return ResponseEntity.ok().build();
	}

	@DeleteMapping("/{userId}")
	public ResponseEntity<String> removeUserInfomation(@PathVariable Long userId) {
		return ResponseEntity.ok().build();
	}

	@GetMapping("/nickname/duplicate/{nickname}")
	public ResponseEntity<Boolean> duplicateCheck(@PathVariable String nickname) {
		final boolean isExist = userService.isDuplicate(nickname);
		return ResponseEntity.ok(isExist);
	}

	@GetMapping("/gateway")
	public ResponseEntity<String> test() {
		return ResponseEntity.ok("main branch");
	}
}
