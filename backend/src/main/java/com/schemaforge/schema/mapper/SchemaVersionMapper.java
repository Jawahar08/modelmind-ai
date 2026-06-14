package com.schemaforge.schema.mapper;

import com.schemaforge.schema.dto.SchemaVersionResponse;
import com.schemaforge.schema.dto.SchemaVersionSummaryResponse;
import com.schemaforge.schema.entity.SchemaVersion;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface SchemaVersionMapper {

    @Mapping(target = "schemaId", source = "schema.id")
    @Mapping(target = "createdById", source = "createdBy.id")
    SchemaVersionResponse toResponse(SchemaVersion schemaVersion);

    @Mapping(target = "schemaId", source = "schema.id")
    @Mapping(target = "createdById", source = "createdBy.id")
    @Mapping(target = "createdByName", source = "createdBy.fullName")
    SchemaVersionSummaryResponse toSummaryResponse(SchemaVersion schemaVersion);
}