package com.ssafy.peelingonion;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

@SpringBootApplication
@EnableZuulProxy
public class PeelingOnionApplication {

	public static void main(String[] args) {
		SpringApplication.run(PeelingOnionApplication.class, args);
	}

}
