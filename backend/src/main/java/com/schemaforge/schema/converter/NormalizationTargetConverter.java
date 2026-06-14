package com.schemaforge.schema.converter;

import com.schemaforge.schema.entity.NormalizationTarget;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter
public class NormalizationTargetConverter implements AttributeConverter<NormalizationTarget, String> {

    @Override
public String convertToDatabaseColumn(NormalizationTarget attribute) {
    return attribute == null ? null : attribute.getValue();
}

@Override
public NormalizationTarget convertToEntityAttribute(String dbData) {
    return dbData == null ? null : NormalizationTarget.fromValue(dbData);
}
}