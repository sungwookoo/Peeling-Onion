package com.ssafy.peelingonion.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.BodyExtractors;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.server.RequestPredicates;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

import java.net.URI;

@Configuration
public class GatewayConfiguration {

    @Bean
    public WebClient webClient() {
        return WebClient.create();
    }

    @Bean
    public RouterFunction<ServerResponse> route(WebClient webClient) {
        return RouterFunctions.route(RequestPredicates.all(), serverRequest -> {
            URI uri = serverRequest.uri();
            String scheme = uri.getScheme();
            String host = uri.getHost();
            String path = uri.getRawPath();

            String apiUrl = scheme + "://" + host + path;
            System.out.println("# apiUrl : "+apiUrl);

            return webClient
                    .method(serverRequest.method())
                    .uri(apiUrl)
                    .headers(headers -> headers.addAll(serverRequest.headers().asHttpHeaders()))
                    .body(BodyInserters.fromDataBuffers(serverRequest.body(BodyExtractors.toDataBuffers())))
                    .exchange()
                    .flatMap(clientResponse -> ServerResponse.status(clientResponse.statusCode())
                            .headers(headers -> headers.addAll(clientResponse.headers().asHttpHeaders()))
                            .body(BodyInserters.fromDataBuffers(clientResponse.body(BodyExtractors.toDataBuffers()))));
        });
    }
}