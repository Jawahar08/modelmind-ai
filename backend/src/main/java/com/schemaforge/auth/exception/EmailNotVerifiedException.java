package com.schemaforge.auth.exception;

import com.schemaforge.common.exception.ForbiddenException;

public class EmailNotVerifiedException extends ForbiddenException {

    public EmailNotVerifiedException() {
        super("Email address has not been verified. Please check your inbox for the verification link.");
    }
}