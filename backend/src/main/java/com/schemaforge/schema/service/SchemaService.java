package com.schemaforge.schema.service;

import com.schemaforge.schema.dto.CreateSchemaRequest;
import com.schemaforge.schema.dto.SchemaResponse;
import com.schemaforge.schema.dto.SchemaSummaryResponse;
import com.schemaforge.schema.dto.SchemaVersionResponse;
import com.schemaforge.schema.dto.SchemaVersionSummaryResponse;
import com.schemaforge.schema.dto.UpdateSchemaRequest;
import com.schemaforge.user.entity.User;

import java.util.List;
import java.util.UUID;

public interface SchemaService {

    SchemaResponse createSchema(User owner, UUID projectId, CreateSchemaRequest request);

    List<SchemaSummaryResponse> getSchemasForProject(User owner, UUID projectId);

    SchemaResponse getSchemaById(User owner, UUID schemaId);

    SchemaResponse updateSchema(User owner, UUID schemaId, UpdateSchemaRequest request);

    void deleteSchema(User owner, UUID schemaId);

    List<SchemaVersionSummaryResponse> getVersionHistory(User owner, UUID schemaId);

    SchemaVersionResponse getVersion(User owner, UUID schemaId, Integer versionNumber);

    SchemaResponse restoreVersion(User owner, UUID schemaId, Integer versionNumber);
}