package com.schemaforge.project.service.impl;

import com.schemaforge.project.dto.CreateProjectRequest;
import com.schemaforge.project.dto.ProjectResponse;
import com.schemaforge.project.dto.UpdateProjectRequest;
import com.schemaforge.project.entity.Project;
import com.schemaforge.project.exception.ProjectNotFoundException;
import com.schemaforge.project.mapper.ProjectMapper;
import com.schemaforge.project.repository.ProjectRepository;
import com.schemaforge.project.service.ProjectService;
import com.schemaforge.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProjectServiceImpl implements ProjectService {

    private final ProjectRepository projectRepository;
    private final ProjectMapper projectMapper;

    @Override
    @Transactional
    public ProjectResponse createProject(User owner, CreateProjectRequest request) {
        Project project = Project.builder()
                .owner(owner)
                .name(request.name())
                .description(request.description())
                .dialect(request.dialect())
                .tags(request.tags() != null ? request.tags() : Collections.emptyList())
                .build();

        Project saved = projectRepository.save(project);

        log.info("Project created: {} (owner: {})", saved.getId(), owner.getEmail());

        return projectMapper.toResponse(saved);
    }

    @Override
    public List<ProjectResponse> getProjectsForUser(User owner) {
        return projectRepository.findAllActiveByOwnerId(owner.getId())
                .stream()
                .map(projectMapper::toResponse)
                .toList();
    }

    @Override
    public ProjectResponse getProjectById(User owner, UUID projectId) {
        Project project = projectRepository.findActiveByIdAndOwnerId(projectId, owner.getId())
                .orElseThrow(() -> new ProjectNotFoundException(projectId));

        return projectMapper.toResponse(project);
    }

    @Override
    @Transactional
    public ProjectResponse updateProject(User owner, UUID projectId, UpdateProjectRequest request) {
        Project project = projectRepository.findActiveByIdAndOwnerId(projectId, owner.getId())
                .orElseThrow(() -> new ProjectNotFoundException(projectId));

        if (request.name() != null) {
            project.setName(request.name());
        }
        if (request.description() != null) {
            project.setDescription(request.description());
        }
        if (request.dialect() != null) {
            project.setDialect(request.dialect());
        }
        if (request.status() != null) {
            project.setStatus(request.status());
        }
        if (request.tags() != null) {
            project.setTags(request.tags());
        }

        Project saved = projectRepository.save(project);

        log.info("Project updated: {} (owner: {})", saved.getId(), owner.getEmail());

        return projectMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public void deleteProject(User owner, UUID projectId) {
        Project project = projectRepository.findActiveByIdAndOwnerId(projectId, owner.getId())
                .orElseThrow(() -> new ProjectNotFoundException(projectId));

        project.setDeletedAt(Instant.now());
        projectRepository.save(project);

        log.info("Project soft-deleted: {} (owner: {})", project.getId(), owner.getEmail());
    }
}