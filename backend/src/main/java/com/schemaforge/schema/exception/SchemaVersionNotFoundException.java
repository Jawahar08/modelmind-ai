package com.schemaforge.schema.exception;

import com.schemaforge.common.exception.ResourceNotFoundException;

import java.util.UUID;

public class SchemaVersionNotFoundException extends ResourceNotFoundException {

    public SchemaVersionNotFoundException(UUID schemaId, Integer versionNumber) {
        super("Version " + versionNumber + " not found for schema: " + schemaId);
    }
}