package com.schemaforge.user.dto;

import com.schemaforge.user.entity.UserRole;
import com.schemaforge.user.entity.UserStatus;

import java.time.Instant;
import java.util.UUID;

public record UserResponse(
        UUID id,
        String email,
        String fullName,
        String avatarUrl,
        UserRole role,
        UserStatus status,
        Integer aiCredits,
        Instant createdAt,
        Instant updatedAt
) {
}