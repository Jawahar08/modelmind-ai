package com.schemaforge.schema.entity;

import com.schemaforge.common.entity.CreatedOnlyEntity;
import com.schemaforge.user.entity.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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

import java.util.Collections;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "schema_versions")
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SchemaVersion extends CreatedOnlyEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schema_id", nullable = false)
    private Schema schema;

    @Column(name = "version_number", nullable = false)
    private Integer versionNumber;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "snapshot_json", columnDefinition = "jsonb", nullable = false)
    @Builder.Default
    private Map<String, Object> snapshot = Collections.emptyMap();

    @Column(name = "change_summary", length = 500)
    private String changeSummary;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by_id", nullable = false)
    private User createdBy;

    
}