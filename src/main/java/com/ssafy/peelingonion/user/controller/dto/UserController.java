package com.ssafy.peelingonion.user.controller.dto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.peelingonion.user.service.UserService;

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

	@PostMapping("/{userId}")
	public ResponseEntity<String> enrollUserInfomation(
		@PathVariable Long userId
	) {
		return ResponseEntity.ok().build();
	}

	@DeleteMapping("/{userId}")
	public ResponseEntity<String> deleteUserInfomation(
		@PathVariable Long userId
	) {
		return ResponseEntity.ok().build();
	}

	@GetMapping("/nickname/duplicate")
	public ResponseEntity<String> duplicateCheck() {
		return ResponseEntity.ok().build();
	}
}
