package com.schemaforge.schema.mapper;

import com.schemaforge.schema.dto.SchemaResponse;
import com.schemaforge.schema.dto.SchemaSummaryResponse;
import com.schemaforge.schema.entity.Schema;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface SchemaMapper {

    @Mapping(target = "projectId", source = "project.id")
    SchemaResponse toResponse(Schema schema);

    @Mapping(target = "projectId", source = "project.id")
    @Mapping(target = "tableCount", expression = "java(schema.getTables() != null ? schema.getTables().size() : 0)")
    SchemaSummaryResponse toSummaryResponse(Schema schema);
}