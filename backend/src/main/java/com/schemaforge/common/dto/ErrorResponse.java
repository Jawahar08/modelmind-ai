package com.schemaforge.common.dto;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.annotation.JsonInclude;

@JsonInclude(JsonInclude.Include.NON_NULL)
public record ErrorResponse(
        boolean success,
        String message,
        String errorCode,
        int status,
        String path,
        Instant timestamp,
        List<FieldError> fieldErrors
) {

    public record FieldError(String field, String message) {
    }

    public static ErrorResponse of(String message, String errorCode, int status, String path) {
        return new ErrorResponse(false, message, errorCode, status, path, Instant.now(), null);
    }

    public static ErrorResponse ofValidation(String message, int status, String path, Map<String, String> errors) {
        List<FieldError> fieldErrors = errors.entrySet().stream()
                .map(e -> new FieldError(e.getKey(), e.getValue()))
                .toList();
        return new ErrorResponse(false, message, "VALIDATION_ERROR", status, path, Instant.now(), fieldErrors);
    }
}