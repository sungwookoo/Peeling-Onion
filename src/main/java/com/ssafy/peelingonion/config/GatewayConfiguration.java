package com.ssafy.peelingonion.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerRequest;
import org.springframework.web.reactive.function.server.ServerResponse;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Configuration
public class GatewayConfiguration {

    private final WebClient webClient;

    public GatewayConfiguration(WebClient.Builder webClientBuilder) {
        this.webClient = webClientBuilder.build();
    }

    @Bean
    public RouterFunction<ServerResponse> apiRoute() {
        return RouterFunctions.route(RequestPredicates.GET("/user/test"), this::handleUserListRequest);
    }

    private Mono<ServerResponse> handleUserListRequest(ServerRequest request) {
        String url = "https://user.ssafy.shop/test";
        System.out.println("##" + url);

        return webClient.get()
                .uri(url)
                .headers(httpHeaders -> httpHeaders.addAll(request.headers().asHttpHeaders()))
                .exchange()
                .flatMap(response -> ServerResponse.status(response.statusCode())
                        .headers(httpHeaders -> httpHeaders.addAll(response.headers().asHttpHeaders()))
                        .body(response.bodyToMono(String.class), String.class));
    }
}