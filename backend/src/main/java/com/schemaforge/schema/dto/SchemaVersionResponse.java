package com.schemaforge.schema.dto;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

public record SchemaVersionResponse(
        UUID id,
        UUID schemaId,
        Integer versionNumber,
        Map<String, Object> snapshot,
        String changeSummary,
        UUID createdById,
        Instant createdAt
) {
}