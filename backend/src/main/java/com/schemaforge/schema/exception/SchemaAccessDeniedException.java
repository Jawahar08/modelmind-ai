package com.schemaforge.schema.exception;

import com.schemaforge.common.exception.ForbiddenException;

public class SchemaAccessDeniedException extends ForbiddenException {

    public SchemaAccessDeniedException() {
        super("You do not have access to this schema");
    }
}