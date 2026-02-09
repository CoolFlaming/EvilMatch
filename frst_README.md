# EvilMatch Database with frst_ Prefix 💀❤️

## Overview

This is a complete **relational database** for EvilMatch - a dating app for villains. All tables use the `frst_` prefix as required.

---

## Database Tables

### Table Structure with frst_ Prefix

```
frst_villains          (Main entity - villain profiles)
frst_lairs             (Villain hideouts)
frst_evil_plans        (World domination schemes)
frst_matches           (Dating connections between villains)
```

---

## Table Relationships

```
┌────────────────────┐
│   frst_villains    │  ← Central table
└──────────┬─────────┘
           │
           │ ONE villain has MANY lairs
           │ ONE villain has MANY evil plans
           │ MANY villains match with MANY villains
           │
           ├──────────────────────┬──────────────────────┐
           │                      │                      │
           ▼                      ▼                      ▼
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   frst_lairs     │  │ frst_evil_plans  │  │  frst_matches    │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

---

## Table Details

### 1. frst_villains

**Purpose:** Stores villain user profiles

**Columns:**
- `villain_id` (PK, AUTO_INCREMENT) - Unique identifier
- `alias` (VARCHAR, NOT NULL, UNIQUE) - Villain name
- `real_name` (VARCHAR) - Secret identity
- `evil_level` (INT, 1-10) - Evil rating
- `preferred_partner_type` (VARCHAR) - Dating preference
- `join_date` (DATE, DEFAULT CURRENT_DATE) - Registration date
- `bio` (TEXT) - Profile description
- `nemesis` (VARCHAR) - Arch-enemy name

**Relationships:**
- One-to-Many → frst_lairs
- One-to-Many → frst_evil_plans
- Many-to-Many → frst_villains (through frst_matches)

---

### 2. frst_lairs

**Purpose:** Stores villain hideouts and secret bases

**Columns:**
- `lair_id` (PK, AUTO_INCREMENT) - Unique identifier
- `villain_id` (FK → frst_villains) - Owner
- `location_name` (VARCHAR, NOT NULL) - Lair location
- `security_level` (INT, 1-5) - Security rating
- `has_lava_moat` (BOOLEAN) - Lava moat feature
- `has_shark_tank` (BOOLEAN) - Shark tank feature
- `square_footage` (INT) - Size of lair

**Relationships:**
- Many-to-One → frst_villains (each lair belongs to one villain)

**Cascade Behavior:**
- ON DELETE CASCADE - If villain deleted, their lairs are deleted

---

### 3. frst_evil_plans

**Purpose:** Tracks villain world domination schemes

**Columns:**
- `plan_id` (PK, AUTO_INCREMENT) - Unique identifier
- `villain_id` (FK → frst_villains) - Plan owner
- `plan_name` (VARCHAR, NOT NULL) - Name of evil plan
- `estimated_completion_year` (INT, ≥2025) - Target year
- `status` (VARCHAR) - 'In Progress', 'Completed', 'Failed', 'On Hold'
- `budget_in_millions` (DECIMAL) - Budget allocation
- `difficulty_rating` (INT, 1-10) - Difficulty level

**Relationships:**
- Many-to-One → frst_villains (each plan belongs to one villain)

**Cascade Behavior:**
- ON DELETE CASCADE - Plans deleted when villain is deleted

---

### 4. frst_matches

**Purpose:** Tracks dating matches between villains

**Columns:**
- `villain_id_1` (PK part 1, FK → frst_villains) - First villain
- `villain_id_2` (PK part 2, FK → frst_villains) - Second villain
- `match_date` (DATE, DEFAULT CURRENT_DATE) - Match date
- `match_status` (VARCHAR) - 'Pending', 'Active', 'Ghosted', 'Evil Ever After'
- `compatibility_score` (INT, 0-100) - Match score
- `first_date_location` (VARCHAR) - First date venue

**Special Features:**
- **Composite Primary Key:** (villain_id_1, villain_id_2)
- **Self-Referencing:** Both FKs point to frst_villains
- **Constraints:**
  - villain_id_1 < villain_id_2 (prevents duplicate pairs)
  - villain_id_1 ≠ villain_id_2 (no self-matching)

**Relationships:**
- Many-to-Many self-referencing relationship (villains matching with villains)

---

## File Structure

```
frst_01_schema.sql          # Database structure (CREATE TABLE statements)
frst_02_sample_data.sql     # Sample data (INSERT statements)
frst_03_queries.sql         # Useful queries and views
frst_README.md              # This documentation file
```

---

## Installation Instructions

### Step 1: Create the Tables

```bash
mysql -u your_username -p your_database_name < frst_01_schema.sql
```

### Step 2: Load Sample Data

```bash
mysql -u your_username -p your_database_name < frst_02_sample_data.sql
```

### Step 3: Run Sample Queries

```bash
mysql -u your_username -p your_database_name < frst_03_queries.sql
```

---

## Sample Queries

### Find all villains with their lair count

```sql
SELECT 
    v.alias,
    COUNT(l.lair_id) AS lair_count
FROM frst_villains v
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias
ORDER BY lair_count DESC;
```

### Show active matches with compatibility scores

```sql
SELECT 
    v1.alias AS villain_1,
    v2.alias AS villain_2,
    m.compatibility_score,
    m.first_date_location
FROM frst_matches m
JOIN frst_villains v1 ON m.villain_id_1 = v1.villain_id
JOIN frst_villains v2 ON m.villain_id_2 = v2.villain_id
WHERE m.match_status = 'Active'
ORDER BY m.compatibility_score DESC;
```

### Find villains with above-average evil level

```sql
SELECT alias, evil_level
FROM frst_villains
WHERE evil_level > (SELECT AVG(evil_level) FROM frst_villains)
ORDER BY evil_level DESC;
```

---

## Views Created

### frst_villain_profile_summary
Complete overview of each villain with counts of lairs, plans, and matches.

```sql
SELECT * FROM frst_villain_profile_summary;
```

### frst_active_dating_pool
Villains currently available for new matches.

```sql
SELECT * FROM frst_active_dating_pool;
```

### frst_evil_plan_dashboard
Overview of all evil plans with villain info.

```sql
SELECT * FROM frst_evil_plan_dashboard WHERE status = 'In Progress';
```

---

## Key Design Features

### ✅ Proper Table Prefix
- All tables use `frst_` prefix
- Consistent naming convention

### ✅ Relational Database Design
- Multiple related tables
- Foreign key relationships
- Referential integrity

### ✅ Normalization (3NF)
- No repeating groups
- No redundant data
- Efficient structure

### ✅ Data Integrity
- Primary keys ensure uniqueness
- Foreign keys ensure referential integrity
- CHECK constraints validate data
- NOT NULL for required fields

### ✅ Relationship Types
- **One-to-Many:** frst_villains → frst_lairs
- **One-to-Many:** frst_villains → frst_evil_plans
- **Many-to-Many:** frst_villains ↔ frst_villains (via frst_matches)

### ✅ Advanced Features
- Composite primary key (frst_matches)
- Self-referencing table (frst_matches)
- CASCADE operations
- Indexes for performance
- Views for complex queries

---

## Sample Data Included

- **10 Villains** with diverse evil levels and preferences
- **12 Lairs** ranging from ice palaces to toxic waste facilities
- **17 Evil Plans** from vampire armies to network shutdowns
- **15 Matches** showing various relationship statuses

---

## Entity Relationship Summary

```
TABLE                 PRIMARY KEY              FOREIGN KEYS
─────────────────────────────────────────────────────────────
frst_villains         villain_id               (none)
frst_lairs            lair_id                  villain_id → frst_villains
frst_evil_plans       plan_id                  villain_id → frst_villains
frst_matches          (villain_id_1,           villain_id_1 → frst_villains
                       villain_id_2)           villain_id_2 → frst_villains
```

---

## Database Characteristics

### Cardinality
- frst_villains to frst_lairs: **1:N** (one villain, many lairs)
- frst_villains to frst_evil_plans: **1:N** (one villain, many plans)
- frst_villains to frst_villains: **M:N** (many villains match many villains)

### Referential Integrity
- All foreign keys have CASCADE DELETE
- Orphaned records automatically removed
- Data consistency maintained

### Constraints Applied
- Primary keys (unique identification)
- Foreign keys (referential integrity)
- CHECK constraints (data validation)
- UNIQUE constraints (no duplicates)
- NOT NULL constraints (required fields)
- DEFAULT values (automatic data)

---

## Next Steps

1. ✅ Tables created with `frst_` prefix
2. ✅ Sample data loaded
3. ✅ Queries and views available
4. 📝 Practice writing your own queries
5. 📝 Experiment with adding new data
6. 📝 Try modifying the schema

---

**Happy Evil Matching! 💀❤️**

*A complete relational database with proper table prefixes and relationships.*
