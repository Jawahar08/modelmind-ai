package com.schemaforge.project.dto;

import com.schemaforge.project.entity.ProjectDialect;
import com.schemaforge.project.entity.ProjectStatus;
import jakarta.validation.constraints.Size;

import java.util.List;

public record UpdateProjectRequest(

        @Size(min = 2, max = 255, message = "Project name must be between 2 and 255 characters")
        String name,

        @Size(max = 2000, message = "Description must not exceed 2000 characters")
        String description,

        ProjectDialect dialect,

        ProjectStatus status,

        List<String> tags
) {
}