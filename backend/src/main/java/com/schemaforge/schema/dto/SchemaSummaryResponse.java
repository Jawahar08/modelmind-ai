package com.schemaforge.schema.dto;

import com.schemaforge.schema.entity.NormalizationTarget;
import com.schemaforge.schema.entity.SchemaStatus;

import java.time.Instant;
import java.util.UUID;

public record SchemaSummaryResponse(
        UUID id,
        UUID projectId,
        String systemName,
        String description,
        NormalizationTarget normalizationTarget,
        SchemaStatus status,
        Integer currentVersion,
        int tableCount,
        Instant createdAt,
        Instant updatedAt
) {
}