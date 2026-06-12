package com.schemaforge.user.dto;

import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(

        @Size(min = 2, max = 255, message = "Full name must be between 2 and 255 characters")
        String fullName,

        @Size(max = 512, message = "Avatar URL must not exceed 512 characters")
        String avatarUrl
) {
}