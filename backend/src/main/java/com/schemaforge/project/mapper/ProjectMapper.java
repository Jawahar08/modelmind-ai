package com.schemaforge.project.mapper;

import com.schemaforge.project.dto.ProjectResponse;
import com.schemaforge.project.entity.Project;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;

import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ProjectMapper {


    @Mapping(target = "ownerId", source = "owner.id")
    ProjectResponse toResponse(Project project);
}