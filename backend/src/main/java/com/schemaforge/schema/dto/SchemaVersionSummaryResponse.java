package com.schemaforge.schema.dto;

import java.time.Instant;
import java.util.UUID;

public record SchemaVersionSummaryResponse(
        UUID id,
        UUID schemaId,
        Integer versionNumber,
        String changeSummary,
        UUID createdById,
        String createdByName,
        Instant createdAt
) {
}