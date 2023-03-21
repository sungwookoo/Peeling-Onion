package com.ssafy.peelingonion.config;

import org.springframework.beans.factory.annotation.Value;
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


@Configuration
public class GatewayConfiguration {

    @Bean
    public WebClient webClient() {
        System.out.println("## Start GatewayConfiguration");
        return WebClient.create();
    }

    @Value("${apiPrefix}")
    private String apiPrefix;

    @Bean
    public RouterFunction<ServerResponse> route(WebClient webClient) {
        System.out.println(apiPrefix);
        return RouterFunctions
                .route(RequestPredicates.GET("https://test.api.ssafy.shop/{service-name}/**")
                                .and(RequestPredicates.accept(MediaType.APPLICATION_JSON)),
                        serverRequest -> {
                            String serviceName = serverRequest.pathVariable("service-name");
                            String apiHost = "test." + serviceName + ".ssafy.shop";
                            String apiUrl = "https://" + apiHost + "/" + apiPrefix + "/" + serviceName + serverRequest.pathVariable("path");
                            System.out.println("## apiUrl : " + apiUrl);
                            return webClient
                                    .get()
                                    .uri(apiUrl)
                                    .headers(headers -> headers.addAll(serverRequest.headers().asHttpHeaders()))
                                    .exchange()
                                    .flatMap(clientResponse -> ServerResponse.status(clientResponse.statusCode())
                                            .headers(headers -> headers.addAll(clientResponse.headers().asHttpHeaders()))
                                            .body(BodyInserters.fromDataBuffers(clientResponse.body(BodyExtractors.toDataBuffers()))));
                        })

                .andRoute(RequestPredicates.GET("https://api.ssafy.shop/{service-name}/**")
                                .and(RequestPredicates.accept(MediaType.APPLICATION_JSON)),
                        serverRequest -> {
                            String serviceName = serverRequest.pathVariable("service-name");
                            String apiHost = serviceName + ".ssafy.shop";
                            String apiUrl = "https://" + apiHost + "/" + apiPrefix + "/" + serviceName + serverRequest.pathVariable("path");
                            System.out.println("## apiUrl : " + apiUrl);
                            return webClient
                                    .get()
                                    .uri(apiUrl)
                                    .headers(headers -> headers.addAll(serverRequest.headers().asHttpHeaders()))
                                    .exchange()
                                    .flatMap(clientResponse -> ServerResponse.status(clientResponse.statusCode())
                                            .headers(headers -> headers.addAll(clientResponse.headers().asHttpHeaders()))
                                            .body(BodyInserters.fromDataBuffers(clientResponse.body(BodyExtractors.toDataBuffers()))));
                        });
    }
}