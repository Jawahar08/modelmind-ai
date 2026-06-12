package com.schemaforge.auth.service.impl;

import com.schemaforge.auth.dto.AuthResponse;
import com.schemaforge.auth.dto.LoginRequest;
import com.schemaforge.auth.dto.RegisterRequest;
import com.schemaforge.auth.exception.InvalidCredentialsException;
import com.schemaforge.auth.service.AuthService;
import com.schemaforge.security.JwtService;
import com.schemaforge.user.entity.User;
import com.schemaforge.user.entity.UserRole;
import com.schemaforge.user.entity.UserStatus;
import com.schemaforge.user.exception.EmailAlreadyExistsException;
import com.schemaforge.user.mapper.UserMapper;
import com.schemaforge.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserMapper userMapper;

    @Override
    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmailIgnoreCase(request.email())) {
            throw new EmailAlreadyExistsException(request.email());
        }

        User user = User.builder()
        .email(request.email().toLowerCase())
        .passwordHash(passwordEncoder.encode(request.password()))
        .fullName(request.fullName())
        .role(UserRole.USER)
        .status(UserStatus.ACTIVE)
        .aiCredits(100)
        .build();

        User savedUser = userRepository.save(user);

        log.info("New user registered: {}", savedUser.getEmail());

        String token = jwtService.generateToken(savedUser);
        return AuthResponse.of(token, userMapper.toResponse(savedUser));
    }

    @Override
    public AuthResponse login(LoginRequest request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.email().toLowerCase(),
                            request.password()
                    )
            );
        } catch (BadCredentialsException ex) {
            throw new InvalidCredentialsException();
        }

        User user = userRepository.findByEmailIgnoreCase(request.email())
                .orElseThrow(InvalidCredentialsException::new);

        String token = jwtService.generateToken(user);

        log.info("User logged in: {}", user.getEmail());

        return AuthResponse.of(token, userMapper.toResponse(user));
    }
}