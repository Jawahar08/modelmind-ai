package com.schemaforge.project.controller;

import com.schemaforge.common.dto.ApiResponse;
import com.schemaforge.project.dto.CreateProjectRequest;
import com.schemaforge.project.dto.ProjectResponse;
import com.schemaforge.project.dto.UpdateProjectRequest;
import com.schemaforge.project.service.ProjectService;
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
@RequestMapping("/api/projects")
@RequiredArgsConstructor
@Tag(name = "Projects", description = "Endpoints for managing user projects")
public class ProjectController {

    private final ProjectService projectService;

    @PostMapping
    @Operation(summary = "Create a project", description = "Creates a new project owned by the authenticated user")
    public ResponseEntity<ApiResponse<ProjectResponse>> createProject(
            @AuthenticationPrincipal User currentUser,
            @Valid @RequestBody CreateProjectRequest request
    ) {
        ProjectResponse response = projectService.createProject(currentUser, request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Project created successfully", response));
    }

    @GetMapping
    @Operation(summary = "List projects", description = "Returns all active projects owned by the authenticated user")
    public ResponseEntity<ApiResponse<List<ProjectResponse>>> getProjects(@AuthenticationPrincipal User currentUser) {
        List<ProjectResponse> response = projectService.getProjectsForUser(currentUser);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{projectId}")
    @Operation(summary = "Get project by id", description = "Returns a single project owned by the authenticated user")
    public ResponseEntity<ApiResponse<ProjectResponse>> getProject(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID projectId
    ) {
        ProjectResponse response = projectService.getProjectById(currentUser, projectId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/{projectId}")
    @Operation(summary = "Update project", description = "Updates fields of an existing project")
    public ResponseEntity<ApiResponse<ProjectResponse>> updateProject(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID projectId,
            @Valid @RequestBody UpdateProjectRequest request
    ) {
        ProjectResponse response = projectService.updateProject(currentUser, projectId, request);
        return ResponseEntity.ok(ApiResponse.success("Project updated successfully", response));
    }

    @DeleteMapping("/{projectId}")
    @Operation(summary = "Delete project", description = "Soft-deletes a project owned by the authenticated user")
    public ResponseEntity<ApiResponse<Void>> deleteProject(
            @AuthenticationPrincipal User currentUser,
            @PathVariable UUID projectId
    ) {
        projectService.deleteProject(currentUser, projectId);
        return ResponseEntity.ok(ApiResponse.message("Project deleted successfully"));
    }
}