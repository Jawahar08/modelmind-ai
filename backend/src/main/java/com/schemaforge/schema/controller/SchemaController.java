package com.schemaforge.schema.controller;

import com.schemaforge.common.dto.ApiResponse;
import com.schemaforge.schema.dto.CreateSchemaRequest;
import com.schemaforge.schema.dto.SchemaResponse;
import com.schemaforge.schema.dto.SchemaSummaryResponse;
import com.schemaforge.schema.dto.SchemaVersionResponse;
import com.schemaforge.schema.dto.SchemaVersionSummaryResponse;
import com.schemaforge.schema.dto.UpdateSchemaRequest;
import com.schemaforge.schema.service.SchemaService;
import com.schemaforge.user.entity.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Tag(name = "Schemas", description = "Endpoints for managing database schemas and their version history")
public class SchemaController {

    private final SchemaService schemaService;

    @PostMapping("/api/projects/{projectId}/schemas")
    @Operation(summary = "Create a schema", description = "Creates a new schema within a project and records version 1")
    public ResponseEntity<ApiResponse<SchemaResponse>> createSchema(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID projectId,
            @Valid @RequestBody CreateSchemaRequest request
    ) {
        SchemaResponse response = schemaService.createSchema(currentUser, projectId, request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Schema created successfully", response));
    }

    @GetMapping("/api/projects/{projectId}/schemas")
    @Operation(summary = "List schemas for a project", description = "Returns all active schemas belonging to a project")
    public ResponseEntity<ApiResponse<List<SchemaSummaryResponse>>> getSchemasForProject(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID projectId
    ) {
        List<SchemaSummaryResponse> response = schemaService.getSchemasForProject(currentUser, projectId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/api/schemas/{schemaId}")
    @Operation(summary = "Get schema by id", description = "Returns the full schema including tables, relationships, and analysis")
    public ResponseEntity<ApiResponse<SchemaResponse>> getSchema(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId
    ) {
        SchemaResponse response = schemaService.getSchemaById(currentUser, schemaId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/api/schemas/{schemaId}")
    @Operation(summary = "Update schema", description = "Updates schema fields and records a new version snapshot")
    public ResponseEntity<ApiResponse<SchemaResponse>> updateSchema(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId,
            @Valid @RequestBody UpdateSchemaRequest request
    ) {
        SchemaResponse response = schemaService.updateSchema(currentUser, schemaId, request);
        return ResponseEntity.ok(ApiResponse.success("Schema updated successfully", response));
    }

    @DeleteMapping("/api/schemas/{schemaId}")
    @Operation(summary = "Delete schema", description = "Soft-deletes a schema")
    public ResponseEntity<ApiResponse<Void>> deleteSchema(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId
    ) {
        schemaService.deleteSchema(currentUser, schemaId);
        return ResponseEntity.ok(ApiResponse.message("Schema deleted successfully"));
    }

    @GetMapping("/api/schemas/{schemaId}/versions")
    @Operation(summary = "Get version history", description = "Returns all version snapshots for a schema, newest first")
    public ResponseEntity<ApiResponse<List<SchemaVersionSummaryResponse>>> getVersionHistory(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId
    ) {
        List<SchemaVersionSummaryResponse> response = schemaService.getVersionHistory(currentUser, schemaId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/api/schemas/{schemaId}/versions/{versionNumber}")
    @Operation(summary = "Get a specific version", description = "Returns the full snapshot for a specific schema version")
    public ResponseEntity<ApiResponse<SchemaVersionResponse>> getVersion(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId,
            @PathVariable Integer versionNumber
    ) {
        SchemaVersionResponse response = schemaService.getVersion(currentUser, schemaId, versionNumber);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/api/schemas/{schemaId}/versions/{versionNumber}/restore")
    @Operation(summary = "Restore a version", description = "Restores the schema to a previous version, recording a new version snapshot")
    public ResponseEntity<ApiResponse<SchemaResponse>> restoreVersion(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID schemaId,
            @PathVariable Integer versionNumber
    ) {
        SchemaResponse response = schemaService.restoreVersion(currentUser, schemaId, versionNumber);
        return ResponseEntity.ok(ApiResponse.success("Schema restored to version " + versionNumber, response));
    }
}