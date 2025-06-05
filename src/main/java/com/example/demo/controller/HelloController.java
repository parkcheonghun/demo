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
}
