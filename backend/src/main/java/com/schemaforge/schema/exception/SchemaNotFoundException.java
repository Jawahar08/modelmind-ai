package com.schemaforge.schema.exception;

import com.schemaforge.common.exception.ResourceNotFoundException;

import java.util.UUID;

public class SchemaNotFoundException extends ResourceNotFoundException {

    public SchemaNotFoundException(UUID id) {
        super("Schema not found with id: " + id);
    }
}