package com.schemaforge.auth.service;

import com.schemaforge.auth.dto.AuthResponse;
import com.schemaforge.auth.dto.LoginRequest;
import com.schemaforge.auth.dto.RegisterRequest;

public interface AuthService {

    AuthResponse register(RegisterRequest request);

    AuthResponse login(LoginRequest request);
}