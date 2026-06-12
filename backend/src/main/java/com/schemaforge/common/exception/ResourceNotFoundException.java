package com.schemaforge.common.exception;

import org.springframework.http.HttpStatus;

public class ResourceNotFoundException extends ApiException {

    public ResourceNotFoundException(String message) {
        super(message, HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
    }

    public static ResourceNotFoundException of(String entityName, Object identifier) {
        return new ResourceNotFoundException(entityName + " not found with identifier: " + identifier);
    }
}