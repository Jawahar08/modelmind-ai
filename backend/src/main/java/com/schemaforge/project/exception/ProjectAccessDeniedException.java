package com.schemaforge.project.exception;

import com.schemaforge.common.exception.ForbiddenException;

public class ProjectAccessDeniedException extends ForbiddenException {

    public ProjectAccessDeniedException() {
        super("You do not have access to this project");
    }
}