package com.schemaforge.schema.entity;

import com.schemaforge.common.entity.BaseEntity;
import com.schemaforge.project.entity.Project;
import com.schemaforge.schema.converter.NormalizationTargetConverter;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "schemas")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Schema extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @Column(name = "system_name", nullable = false)
    private String systemName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Convert(converter = NormalizationTargetConverter.class)
    @Column(name = "normalization_target", nullable = false, length = 10)
    @Builder.Default
    private NormalizationTarget normalizationTarget = NormalizationTarget.THREE_NF;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "tables_json", columnDefinition = "jsonb", nullable = false)
    @Builder.Default
    private List<Map<String, Object>> tables = Collections.emptyList();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "relationships_json", columnDefinition = "jsonb", nullable = false)
    @Builder.Default
    private List<Map<String, Object>> relationships = Collections.emptyList();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "normalization_notes_json", columnDefinition = "jsonb", nullable = false)
    @Builder.Default
    private List<Map<String, Object>> normalizationNotes = Collections.emptyList();

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "analysis_items_json", columnDefinition = "jsonb", nullable = false)
    @Builder.Default
    private List<Map<String, Object>> analysisItems = Collections.emptyList();

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    @Builder.Default
    private SchemaStatus status = SchemaStatus.DRAFT;

    @Column(name = "current_version", nullable = false)
    @Builder.Default
    private Integer currentVersion = 1;

    @Column(name = "deleted_at")
    private Instant deletedAt;
}