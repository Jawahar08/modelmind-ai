package com.schemaforge.schema.repository;

import com.schemaforge.schema.entity.SchemaVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface SchemaVersionRepository extends JpaRepository<SchemaVersion, UUID> {

    @Query("SELECT sv FROM SchemaVersion sv WHERE sv.schema.id = :schemaId ORDER BY sv.versionNumber DESC")
    List<SchemaVersion> findAllBySchemaIdOrderByVersionDesc(@Param("schemaId") UUID schemaId);

    Optional<SchemaVersion> findBySchemaIdAndVersionNumber(UUID schemaId, Integer versionNumber);

    @Query("SELECT COALESCE(MAX(sv.versionNumber), 0) FROM SchemaVersion sv WHERE sv.schema.id = :schemaId")
    Integer findMaxVersionNumber(@Param("schemaId") UUID schemaId);
}