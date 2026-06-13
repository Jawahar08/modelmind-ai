package com.schemaforge.project.exception;

import com.schemaforge.common.exception.ResourceNotFoundException;

import java.util.UUID;

public class ProjectNotFoundException extends ResourceNotFoundException {

    public ProjectNotFoundException(UUID id) {
        super("Project not found with id: " + id);
    }
}