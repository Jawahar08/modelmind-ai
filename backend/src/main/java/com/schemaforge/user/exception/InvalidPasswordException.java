package com.schemaforge.user.exception;

import com.schemaforge.common.exception.BadRequestException;

public class InvalidPasswordException extends BadRequestException {

    public InvalidPasswordException(String message) {
        super(message);
    }
}