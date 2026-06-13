package com.schemaforge.project.service;

import com.schemaforge.project.dto.CreateProjectRequest;
import com.schemaforge.project.dto.ProjectResponse;
import com.schemaforge.project.dto.UpdateProjectRequest;
import com.schemaforge.user.entity.User;

import java.util.List;
import java.util.UUID;

public interface ProjectService {

    ProjectResponse createProject(User owner, CreateProjectRequest request);

    List<ProjectResponse> getProjectsForUser(User owner);

    ProjectResponse getProjectById(User owner, UUID projectId);

    ProjectResponse updateProject(User owner, UUID projectId, UpdateProjectRequest request);

    void deleteProject(User owner, UUID projectId);
}