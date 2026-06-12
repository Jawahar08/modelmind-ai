-- ============================================================
-- V11__seed_dev_data.sql
-- Development seed data. Only applied when the 'dev' Spring
-- profile is active (controlled via flyway.locations in
-- application-dev.yml, which includes this file's directory;
-- application-prod.yml excludes it).
--
-- Password for both seed users is: Password123!
-- BCrypt hash below corresponds to that plaintext (cost factor 10).
-- ============================================================

-- ------------------------------------------------------------
-- Users
-- ------------------------------------------------------------
INSERT INTO users (id, email, password_hash, full_name, role, status, ai_credits, created_at, updated_at)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'jane@schemaforge.ai',
     '$2a$10$DowQGz4z3rJ7s0z6sV0g4.YfYqz3v0R0iJ3X8r5L1bX0nQqJ2qFy6',
     'Jane Developer', 'USER', 'ACTIVE', 480, now(), now()),

    ('22222222-2222-2222-2222-222222222222', 'admin@schemaforge.ai',
     '$2a$10$DowQGz4z3rJ7s0z6sV0g4.YfYqz3v0R0iJ3X8r5L1bX0nQqJ2qFy6',
     'Alex Admin', 'ADMIN', 'ACTIVE', 999999, now(), now());

-- ------------------------------------------------------------
-- Teams
-- ------------------------------------------------------------
INSERT INTO teams (id, name, slug, description, owner_id, plan, created_at, updated_at)
VALUES
    ('33333333-3333-3333-3333-333333333333', 'Acme Engineering', 'acme-engineering',
     'Core product engineering team', '11111111-1111-1111-1111-111111111111', 'TEAM', now(), now());

INSERT INTO team_members (id, team_id, user_id, role, joined_at)
VALUES
    ('44444444-4444-4444-4444-444444444444', '33333333-3333-3333-3333-333333333333',
     '11111111-1111-1111-1111-111111111111', 'OWNER', now()),
    ('55555555-5555-5555-5555-555555555555', '33333333-3333-3333-3333-333333333333',
     '22222222-2222-2222-2222-222222222222', 'ADMIN', now());

-- ------------------------------------------------------------
-- Projects
-- ------------------------------------------------------------
INSERT INTO projects (id, owner_id, team_id, name, description, dialect, status, tags, created_at, updated_at)
VALUES
    ('66666666-6666-6666-6666-666666666666',
     '11111111-1111-1111-1111-111111111111',
     '33333333-3333-3333-3333-333333333333',
     'E-commerce Platform',
     'Customers place orders; products belong to categories; sellers manage inventory; payments tracked with line items.',
     'postgresql', 'ACTIVE', '["commerce", "users", "inventory"]'::jsonb, now(), now()),

    ('77777777-7777-7777-7777-777777777777',
     '11111111-1111-1111-1111-111111111111',
     NULL,
     'Hospital Management',
     'Doctors, patients, appointments, prescriptions, wards, nurses, and billing.',
     'mysql', 'ACTIVE', '["medical", "scheduling", "billing"]'::jsonb, now(), now());

-- ------------------------------------------------------------
-- Schemas (one for the E-commerce project)
-- ------------------------------------------------------------
INSERT INTO schemas (
    id, project_id, system_name, description, normalization_target,
    tables_json, relationships_json, normalization_notes_json, analysis_items_json,
    status, current_version, created_at, updated_at
)
VALUES (
    '88888888-8888-8888-8888-888888888888',
    '66666666-6666-6666-6666-666666666666',
    'E-commerce Platform',
    'Multi-seller marketplace with order management and inventory tracking.',
    '3nf',
    '[
        {
            "name": "customers",
            "description": "Registered customers who place orders",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Customer identifier"},
                {"name": "email", "type": "VARCHAR(255)", "constraints": ["NOT NULL", "UNIQUE"], "description": "Customer email"},
                {"name": "full_name", "type": "VARCHAR(255)", "constraints": ["NOT NULL"], "description": "Customer full name"},
                {"name": "created_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "description": "Registration timestamp"}
            ],
            "indexes": ["CREATE INDEX idx_customers_email ON customers(email)"]
        },
        {
            "name": "categories",
            "description": "Product category hierarchy",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Category identifier"},
                {"name": "name", "type": "VARCHAR(255)", "constraints": ["NOT NULL"], "description": "Category name"},
                {"name": "parent_category_id", "type": "UUID", "constraints": [], "description": "Parent category for nesting", "references": "categories.id"}
            ],
            "indexes": []
        },
        {
            "name": "sellers",
            "description": "Marketplace sellers managing inventory",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Seller identifier"},
                {"name": "business_name", "type": "VARCHAR(255)", "constraints": ["NOT NULL"], "description": "Seller business name"},
                {"name": "email", "type": "VARCHAR(255)", "constraints": ["NOT NULL", "UNIQUE"], "description": "Seller contact email"}
            ],
            "indexes": []
        },
        {
            "name": "products",
            "description": "Items available for purchase",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Product identifier"},
                {"name": "seller_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Owning seller", "references": "sellers.id"},
                {"name": "category_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Product category", "references": "categories.id"},
                {"name": "name", "type": "VARCHAR(255)", "constraints": ["NOT NULL"], "description": "Product name"},
                {"name": "price_cents", "type": "INTEGER", "constraints": ["NOT NULL"], "description": "Price in smallest currency unit"},
                {"name": "stock_quantity", "type": "INTEGER", "constraints": ["NOT NULL", "DEFAULT 0"], "description": "Units in stock"}
            ],
            "indexes": ["CREATE INDEX idx_products_category ON products(category_id)", "CREATE INDEX idx_products_seller ON products(seller_id)"]
        },
        {
            "name": "orders",
            "description": "Customer purchase orders",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Order identifier"},
                {"name": "customer_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Ordering customer", "references": "customers.id"},
                {"name": "status", "type": "VARCHAR(20)", "constraints": ["NOT NULL", "DEFAULT ''PENDING''"], "description": "Order status"},
                {"name": "total_cents", "type": "INTEGER", "constraints": ["NOT NULL"], "description": "Order total in smallest currency unit"},
                {"name": "created_at", "type": "TIMESTAMP", "constraints": ["NOT NULL"], "description": "Order placed timestamp"}
            ],
            "indexes": ["CREATE INDEX idx_orders_customer ON orders(customer_id)"]
        },
        {
            "name": "order_items",
            "description": "Line items belonging to an order",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Line item identifier"},
                {"name": "order_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Parent order", "references": "orders.id"},
                {"name": "product_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Purchased product", "references": "products.id"},
                {"name": "quantity", "type": "INTEGER", "constraints": ["NOT NULL"], "description": "Quantity ordered"},
                {"name": "unit_price_cents", "type": "INTEGER", "constraints": ["NOT NULL"], "description": "Price at time of purchase"}
            ],
            "indexes": ["CREATE INDEX idx_order_items_order ON order_items(order_id)"]
        },
        {
            "name": "payments",
            "description": "Payment transactions for orders",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Payment identifier"},
                {"name": "order_id", "type": "UUID", "constraints": ["NOT NULL", "UNIQUE"], "description": "Associated order", "references": "orders.id"},
                {"name": "amount_cents", "type": "INTEGER", "constraints": ["NOT NULL"], "description": "Amount charged"},
                {"name": "status", "type": "VARCHAR(20)", "constraints": ["NOT NULL"], "description": "Payment status"},
                {"name": "processed_at", "type": "TIMESTAMP", "constraints": [], "description": "When payment was processed"}
            ],
            "indexes": []
        },
        {
            "name": "reviews",
            "description": "Customer product reviews",
            "fields": [
                {"name": "id", "type": "UUID", "constraints": ["PRIMARY KEY"], "description": "Review identifier"},
                {"name": "product_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Reviewed product", "references": "products.id"},
                {"name": "customer_id", "type": "UUID", "constraints": ["NOT NULL"], "description": "Reviewing customer", "references": "customers.id"},
                {"name": "rating", "type": "SMALLINT", "constraints": ["NOT NULL"], "description": "Rating 1-5"},
                {"name": "comment", "type": "TEXT", "constraints": [], "description": "Review text"}
            ],
            "indexes": ["CREATE INDEX idx_reviews_product ON reviews(product_id)"]
        }
    ]'::jsonb,
    '[
        {"from": "products", "to": "categories", "type": "one-to-many", "description": "Each product belongs to one category"},
        {"from": "products", "to": "sellers", "type": "one-to-many", "description": "Each product is managed by one seller"},
        {"from": "orders", "to": "customers", "type": "one-to-many", "description": "Each order is placed by one customer"},
        {"from": "order_items", "to": "orders", "type": "one-to-many", "description": "Each order has many line items"},
        {"from": "order_items", "to": "products", "type": "one-to-many", "description": "Each line item references one product"},
        {"from": "payments", "to": "orders", "type": "one-to-one", "description": "Each order has exactly one payment record"},
        {"from": "reviews", "to": "products", "type": "one-to-many", "description": "Each product can have many reviews"},
        {"from": "reviews", "to": "customers", "type": "one-to-many", "description": "Each customer can write many reviews"}
    ]'::jsonb,
    '[
        {"level": "1NF", "status": "satisfied", "notes": "All columns contain atomic values; no repeating groups."},
        {"level": "2NF", "status": "satisfied", "notes": "No partial dependencies; all non-key attributes depend on the full primary key."},
        {"level": "3NF", "status": "satisfied", "notes": "No transitive dependencies; order totals are stored but derivable, flagged as an acceptable denormalization for performance."},
        {"level": "BCNF", "status": "satisfied", "notes": "Every determinant is a candidate key."}
    ]'::jsonb,
    '[
        {"type": "success", "title": "Primary keys defined", "description": "All tables have UUID primary keys."},
        {"type": "success", "title": "Referential integrity enforced", "description": "Foreign keys link order_items to orders and products correctly."},
        {"type": "info", "title": "Consider soft deletes", "description": "Adding deleted_at to products and orders would support order history after product removal."},
        {"type": "warning", "title": "orders.total_cents is denormalized", "description": "This value is derivable from order_items but stored for query performance; ensure it is recalculated on item changes."}
    ]'::jsonb,
    'FINAL', 1, now(), now()
);

-- ------------------------------------------------------------
-- Schema version snapshot (version 1)
-- ------------------------------------------------------------
INSERT INTO schema_versions (id, schema_id, version_number, snapshot_json, change_summary, created_by_id, created_at)
SELECT
    '99999999-9999-9999-9999-999999999999',
    s.id,
    1,
    jsonb_build_object(
        'systemName', s.system_name,
        'description', s.description,
        'tables', s.tables_json,
        'relationships', s.relationships_json
    ),
    'Initial schema generation',
    '11111111-1111-1111-1111-111111111111',
    now()
FROM schemas s
WHERE s.id = '88888888-8888-8888-8888-888888888888';

-- ------------------------------------------------------------
-- AI request log entries
-- ------------------------------------------------------------
INSERT INTO ai_requests (
    id, user_id, schema_id, request_type, provider, model,
    prompt, response, prompt_tokens, completion_tokens, latency_ms, status, created_at
)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
     '11111111-1111-1111-1111-111111111111',
     '88888888-8888-8888-8888-888888888888',
     'SCHEMA_GENERATION', 'CLAUDE', 'claude-sonnet-4-20250514',
     'Build an e-commerce platform where customers place orders...',
     '{"systemName": "E-commerce Platform", "tables": [...]}',
     420, 1380, 4200, 'SUCCESS', now() - interval '2 days'),

    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
     '11111111-1111-1111-1111-111111111111',
     '88888888-8888-8888-8888-888888888888',
     'SCHEMA_REVIEW', 'CLAUDE', 'claude-sonnet-4-20250514',
     'Review the following schema for normalization issues...',
     '{"analysisItems": [...]}',
     680, 310, 2100, 'SUCCESS', now() - interval '1 day');

-- ------------------------------------------------------------
-- Comments
-- ------------------------------------------------------------
INSERT INTO comments (id, project_id, schema_id, user_id, content, entity_reference, resolved, created_at, updated_at)
VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccccc',
     '66666666-6666-6666-6666-666666666666',
     '88888888-8888-8888-8888-888888888888',
     '22222222-2222-2222-2222-222222222222',
     'Should we add a soft-delete flag to products in case sellers remove items mid-order?',
     'table:products', false, now() - interval '12 hours', now() - interval '12 hours');

-- ------------------------------------------------------------
-- Exports
-- ------------------------------------------------------------
INSERT INTO exports (id, project_id, schema_id, schema_version_id, requested_by_id, export_type, dialect, status, file_url, file_size_bytes, created_at, completed_at)
VALUES
    ('dddddddd-dddd-dddd-dddd-dddddddddddd',
     '66666666-6666-6666-6666-666666666666',
     '88888888-8888-8888-8888-888888888888',
     '99999999-9999-9999-9999-999999999999',
     '11111111-1111-1111-1111-111111111111',
     'SQL', 'postgresql', 'COMPLETED',
     'https://storage.schemaforge.ai/exports/ecommerce-platform-v1.sql', 8420,
     now() - interval '1 day', now() - interval '1 day' + interval '5 seconds');

-- ------------------------------------------------------------
-- Notifications
-- ------------------------------------------------------------
INSERT INTO notifications (id, user_id, type, title, message, metadata_json, read, created_at)
VALUES
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
     '11111111-1111-1111-1111-111111111111',
     'SCHEMA_GENERATED', 'Schema generated',
     'Your schema for "E-commerce Platform" is ready to review.',
     jsonb_build_object('projectId', '66666666-6666-6666-6666-666666666666', 'schemaId', '88888888-8888-8888-8888-888888888888'),
     true, now() - interval '2 days'),

    ('ffffffff-ffff-ffff-ffff-ffffffffffff',
     '11111111-1111-1111-1111-111111111111',
     'COMMENT_ADDED', 'New comment on E-commerce Platform',
     'Alex Admin commented on the products table.',
     jsonb_build_object('projectId', '66666666-6666-6666-6666-666666666666', 'commentId', 'cccccccc-cccc-cccc-cccc-cccccccccccc'),
     false, now() - interval '12 hours');

-- ------------------------------------------------------------
-- Audit logs
-- ------------------------------------------------------------
INSERT INTO audit_logs (id, user_id, action, entity_type, entity_id, after_state_json, ip_address, created_at)
VALUES
    (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'PROJECT_CREATED', 'PROJECT',
     '66666666-6666-6666-6666-666666666666',
     jsonb_build_object('name', 'E-commerce Platform', 'dialect', 'postgresql'),
     '203.0.113.10', now() - interval '3 days'),

    (gen_random_uuid(), '11111111-1111-1111-1111-111111111111', 'SCHEMA_GENERATED', 'SCHEMA',
     '88888888-8888-8888-8888-888888888888',
     jsonb_build_object('systemName', 'E-commerce Platform', 'tableCount', 8),
     '203.0.113.10', now() - interval '2 days');
