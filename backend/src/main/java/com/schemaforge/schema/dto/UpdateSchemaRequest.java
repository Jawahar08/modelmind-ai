package com.schemaforge.schema.dto;

import com.schemaforge.schema.entity.NormalizationTarget;
import com.schemaforge.schema.entity.SchemaStatus;
import jakarta.validation.constraints.Size;

import java.util.List;
import java.util.Map;

public record UpdateSchemaRequest(

        @Size(max = 255, message = "System name must not exceed 255 characters")
        String systemName,

        @Size(max = 2000, message = "Description must not exceed 2000 characters")
        String description,

        NormalizationTarget normalizationTarget,

        List<Map<String, Object>> tables,

        List<Map<String, Object>> relationships,

        List<Map<String, Object>> normalizationNotes,

        List<Map<String, Object>> analysisItems,

        SchemaStatus status,

        @Size(max = 500, message = "Change summary must not exceed 500 characters")
        String changeSummary
) {
}