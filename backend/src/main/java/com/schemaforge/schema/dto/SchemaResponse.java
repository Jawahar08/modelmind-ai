package com.schemaforge.schema.dto;

import com.schemaforge.schema.entity.NormalizationTarget;
import com.schemaforge.schema.entity.SchemaStatus;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public record SchemaResponse(
        UUID id,
        UUID projectId,
        String systemName,
        String description,
        NormalizationTarget normalizationTarget,
        List<Map<String, Object>> tables,
        List<Map<String, Object>> relationships,
        List<Map<String, Object>> normalizationNotes,
        List<Map<String, Object>> analysisItems,
        SchemaStatus status,
        Integer currentVersion,
        Instant createdAt,
        Instant updatedAt
) {
}