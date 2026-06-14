package com.schemaforge.schema.entity;

public enum NormalizationTarget {
    TWO_NF("2nf"),
    THREE_NF("3nf"),
    BCNF("bcnf");

    private final String value;

    NormalizationTarget(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }

    public static NormalizationTarget fromValue(String value) {
        for (NormalizationTarget target : values()) {
            if (target.value.equalsIgnoreCase(value)) {
                return target;
            }
        }
        throw new IllegalArgumentException("Unknown normalization target: " + value);
    }
}