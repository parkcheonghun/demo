package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello, Spring Boot, here is docker container execute !";
    }

    @GetMapping("/actuator/health/liveness")
    public String liveness() {
        return "Pods liveness";
    }

    @GetMapping("/actuator/health/readiness")
    public String readiness() {
        return "Pods readiness";
    }

    @GetMapping("/greeting")
    public String greeting() {
        return "Welcome to our Spring Boot application!";
    }

    @GetMapping("/newEndpoint")
    public String newEndpoint() {
        return "This is a new endpoint";
    }

    @GetMapping("/")
    public String home() {
        return "Welcome to the home page!";
    }
}
