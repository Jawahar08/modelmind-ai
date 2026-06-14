package com.schemaforge.schema.dto;

import com.schemaforge.schema.entity.NormalizationTarget;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;
import java.util.Map;

public record CreateSchemaRequest(

        @NotBlank(message = "System name is required")
        @Size(max = 255, message = "System name must not exceed 255 characters")
        String systemName,

        @Size(max = 2000, message = "Description must not exceed 2000 characters")
        String description,

        @NotNull(message = "Normalization target is required")
        NormalizationTarget normalizationTarget,

        @NotNull(message = "Tables are required")
        List<Map<String, Object>> tables,

        List<Map<String, Object>> relationships,

        List<Map<String, Object>> normalizationNotes,

        List<Map<String, Object>> analysisItems
) {
}