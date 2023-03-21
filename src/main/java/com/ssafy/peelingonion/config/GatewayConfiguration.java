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

@Configuration
public class GatewayConfiguration {

    @Bean
    public WebClient webClient() {
        System.out.println("## Start GatewayConfiguration");
        return WebClient.create();
    }

    @Bean
    public RouterFunction<ServerResponse> route(WebClient webClient) {
        System.out.println("## Into route method");
        return RouterFunctions
                .route(RequestPredicates.GET("/user")
//                .route(RequestPredicates.GET("https://api.ssafy.shop/{service-name}/**")
                                .and(RequestPredicates.accept(MediaType.APPLICATION_JSON)),
                        serverRequest -> {
                            System.out.println("## success get");
                            String serviceName = serverRequest.pathVariable("service-name");
                            String apiHost = serviceName + ".ssafy.shop";
                            String apiUrl = serverRequest.uri().getPath().replace("/" + serviceName, "");
                            String fullUrl = "https://" + apiHost + apiUrl;
                            System.out.println("## FullUrl : " + fullUrl);

                            return webClient
                                    .get()
                                    .uri(fullUrl)
                                    .headers(headers -> headers.addAll(serverRequest.headers().asHttpHeaders()))
                                    .exchange()
                                    .flatMap(clientResponse -> ServerResponse.status(clientResponse.statusCode())
                                            .headers(headers -> headers.addAll(clientResponse.headers().asHttpHeaders()))
                                            .body(BodyInserters.fromDataBuffers(clientResponse.body(BodyExtractors.toDataBuffers()))));
                        })

                .andRoute(RequestPredicates.GET("https://test.api.ssafy.shop/{service-name}/**")
                                .and(RequestPredicates.accept(MediaType.APPLICATION_JSON)),
                        serverRequest -> {
                            String serviceName = serverRequest.pathVariable("service-name");
                            String apiHost = serviceName + ".ssafy.shop";
                            String apiUrl = serverRequest.uri().getPath().replace("/" + serviceName, "");
                            String fullUrl = "https://" + "test." + apiHost + apiUrl;
                            return webClient
                                    .get()
                                    .uri(fullUrl)
                                    .headers(headers -> headers.addAll(serverRequest.headers().asHttpHeaders()))
                                    .exchange()
                                    .flatMap(clientResponse -> ServerResponse.status(clientResponse.statusCode())
                                            .headers(headers -> headers.addAll(clientResponse.headers().asHttpHeaders()))
                                            .body(BodyInserters.fromDataBuffers(clientResponse.body(BodyExtractors.toDataBuffers()))));
                        });
    }
}