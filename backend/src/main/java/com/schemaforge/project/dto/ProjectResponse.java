package com.schemaforge.project.dto;

import com.schemaforge.project.entity.ProjectDialect;
import com.schemaforge.project.entity.ProjectStatus;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record ProjectResponse(
        UUID id,
        String name,
        String description,
        ProjectDialect dialect,
        ProjectStatus status,
        List<String> tags,
        UUID ownerId,
        Instant createdAt,
        Instant updatedAt
) {
}