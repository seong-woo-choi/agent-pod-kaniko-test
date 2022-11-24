package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    // 회원가입
    @GetMapping("/")
    public String hello() {
        return "hello";
    }

}

