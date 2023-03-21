package com.ssafy.peelingonion.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import reactor.core.publisher.Mono;

@Configuration
public class ApiGatewayConfiguration {

    @Bean
    public RouterFunction<ServerResponse> route() {
        return RouterFunctions
                .route()
                .GET("/user/{path}", this::handleUserRequest)
                .GET("/alarm/{path}", this::handleAlarmRequest)
                .build();
    }

    private Mono<ServerResponse> handleUserRequest(ServerRequest req) {
        String path = req.pathVariable("path");
        // WebClient를 사용하여 요청을 전달하고 응답을 받아 처리하도록 구현해야 합니다.
        // 이 예제에서는 단순히 주소만 변경합니다.
        return ServerResponse.ok().bodyValue("https://user.ssafy.shop/" + path);
    }

    private Mono<ServerResponse> handleAlarmRequest(ServerRequest req) {
        String path = req.pathVariable("path");
        // WebClient를 사용하여 요청을 전달하고 응답을 받아 처리하도록 구현해야 합니다.
        // 이 예제에서는 단순히 주소만 변경합니다.
        return ServerResponse.ok().bodyValue("https://alarm.ssafy.shop/" + path);
    }
}
