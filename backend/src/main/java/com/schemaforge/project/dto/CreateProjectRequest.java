package com.schemaforge.project.dto;

import com.schemaforge.project.entity.ProjectDialect;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public record CreateProjectRequest(

        @NotBlank(message = "Project name is required")
        @Size(min = 2, max = 255, message = "Project name must be between 2 and 255 characters")
        String name,

        @Size(max = 2000, message = "Description must not exceed 2000 characters")
        String description,

        @NotNull(message = "Dialect is required")
        ProjectDialect dialect,

        List<String> tags
) {
}