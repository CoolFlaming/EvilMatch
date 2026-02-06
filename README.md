# EvilMatch Database 💀❤️
### A Dating App for Villains

---

## 📖 Overview

EvilMatch is a comprehensive SQL database designed to manage a dating application for villains. The database handles villain profiles, their secret lairs, evil plans, and romantic matches between villains.

## 🗂️ Database Structure

### Tables

1. **Villains** - Core user profiles
2. **Lairs** - Villain hideouts and secret bases
3. **Evil_Plans** - World domination schemes and evil objectives
4. **Matches** - Dating connections between villains

### Relationships

```
Villains (1) ──────< (Many) Lairs
Villains (1) ──────< (Many) Evil_Plans
Villains (Many) ──< (Many) Villains (Self-Referencing through Matches)
```

---

## 🚀 Getting Started

### Installation Instructions

1. **Run the schema file first:**
   ```bash
   mysql -u your_username -p your_database_name < 01_schema.sql
   ```

2. **Load sample data:**
   ```bash
   mysql -u your_username -p your_database_name < 02_sample_data.sql
   ```

3. **Try the queries:**
   ```bash
   mysql -u your_username -p your_database_name < 03_queries.sql
   ```

### Alternative (Interactive MySQL)

```sql
source /path/to/01_schema.sql;
source /path/to/02_sample_data.sql;
source /path/to/03_queries.sql;
```

---

## 📊 Table Details

### 1. Villains Table

**Primary Key:** `villain_id`

| Column | Type | Description |
|--------|------|-------------|
| villain_id | INT | Auto-incrementing unique identifier |
| alias | VARCHAR(100) | Villain name (UNIQUE, NOT NULL) |
| real_name | VARCHAR(100) | Secret identity |
| evil_level | INT | Evil rating from 1-10 |
| preferred_partner_type | VARCHAR(50) | Dating preference |
| join_date | DATE | Registration date |
| bio | TEXT | Profile description |
| nemesis | VARCHAR(100) | Arch-enemy name |

**Constraints:**
- `evil_level` must be between 1 and 10
- `alias` must be unique
- Indexed on `alias` and `evil_level` for performance

---

### 2. Lairs Table

**Primary Key:** `lair_id`  
**Foreign Key:** `villain_id` → Villains.villain_id

| Column | Type | Description |
|--------|------|-------------|
| lair_id | INT | Auto-incrementing unique identifier |
| villain_id | INT | Owner of the lair |
| location_name | VARCHAR(150) | Lair location |
| security_level | INT | Security rating 1-5 |
| has_lava_moat | BOOLEAN | Lava moat feature |
| has_shark_tank | BOOLEAN | Shark tank feature |
| square_footage | INT | Size of the lair |

**Constraints:**
- `security_level` must be between 1 and 5
- CASCADE delete: If villain deleted, lairs are deleted
- One-to-Many: One villain can have multiple lairs

---

### 3. Evil_Plans Table

**Primary Key:** `plan_id`  
**Foreign Key:** `villain_id` → Villains.villain_id

| Column | Type | Description |
|--------|------|-------------|
| plan_id | INT | Auto-incrementing unique identifier |
| villain_id | INT | Plan owner |
| plan_name | VARCHAR(200) | Name of the evil plan |
| estimated_completion_year | INT | Target completion year (≥2025) |
| status | VARCHAR(20) | Plan status |
| budget_in_millions | DECIMAL(10,2) | Budget allocation |
| difficulty_rating | INT | Difficulty level 1-10 |

**Valid Status Values:**
- In Progress
- Completed
- Failed
- On Hold

**Constraints:**
- `estimated_completion_year` must be ≥ 2025
- `difficulty_rating` must be between 1 and 10
- CASCADE delete: Plans deleted when villain is deleted

---

### 4. Matches Table

**Composite Primary Key:** `(villain_id_1, villain_id_2)`  
**Foreign Keys:** Both reference Villains.villain_id

| Column | Type | Description |
|--------|------|-------------|
| villain_id_1 | INT | First villain in match |
| villain_id_2 | INT | Second villain in match |
| match_date | DATE | Date of match |
| match_status | VARCHAR(20) | Current relationship status |
| compatibility_score | INT | Match score 0-100 |
| first_date_location | VARCHAR(100) | First date venue |

**Valid Match Status Values:**
- Pending
- Active
- Ghosted
- Evil Ever After

**Constraints:**
- `villain_id_1` must be less than `villain_id_2` (prevents duplicate pairs)
- `villain_id_1` ≠ `villain_id_2` (no self-matching)
- `compatibility_score` must be between 0 and 100
- Many-to-Many self-referencing relationship

---

## 🔍 Key Design Features

### ✅ Normalization (3NF)
- No repeating groups
- All non-key attributes depend on primary key
- No transitive dependencies

### ✅ Referential Integrity
- Foreign keys with CASCADE options
- CHECK constraints for data validation
- UNIQUE constraints prevent duplicates

### ✅ Relationship Types
- **One-to-Many:** Villains → Lairs
- **One-to-Many:** Villains → Evil_Plans
- **Many-to-Many:** Villains ↔ Villains (self-referencing through Matches)

### ✅ Data Integrity
- Composite primary key in Matches table
- Self-match prevention
- Ordered pairs prevention (no duplicate matches)
- CHECK constraints on all enum-like fields

### ✅ Performance Optimization
- Strategic indexes on foreign keys
- Indexes on frequently queried fields
- Pre-built views for complex queries

---

## 📈 Useful Queries

### Find villains with most lairs
```sql
SELECT v.alias, COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias
ORDER BY lair_count DESC;
```

### Active matches with compatibility scores
```sql
SELECT v1.alias, v2.alias, m.compatibility_score, m.first_date_location
FROM Matches m
JOIN Villains v1 ON m.villain_id_1 = v1.villain_id
JOIN Villains v2 ON m.villain_id_2 = v2.villain_id
WHERE m.match_status = 'Active'
ORDER BY m.compatibility_score DESC;
```

### Most ambitious evil plans
```sql
SELECT v.alias, ep.plan_name, ep.difficulty_rating, ep.budget_in_millions
FROM Evil_Plans ep
JOIN Villains v ON ep.villain_id = v.villain_id
WHERE ep.status = 'In Progress'
ORDER BY ep.difficulty_rating DESC, ep.budget_in_millions DESC;
```

---

## 📊 Pre-Built Views

### Villain_Profile_Summary
Complete overview of each villain including counts of lairs, plans, and matches.

```sql
SELECT * FROM Villain_Profile_Summary ORDER BY evil_level DESC;
```

### Active_Dating_Pool
Villains currently available for new matches (fewer than 3 active matches).

```sql
SELECT * FROM Active_Dating_Pool;
```

### Evil_Plan_Dashboard
Overview of all evil plans with associated villain info.

```sql
SELECT * FROM Evil_Plan_Dashboard WHERE status = 'In Progress';
```

---

## 🎯 Sample Data Included

The database comes pre-populated with:
- **10 Villains** with diverse evil levels and preferences
- **12 Lairs** ranging from ice palaces to toxic waste facilities
- **17 Evil Plans** from vampire armies to network shutdowns
- **15 Matches** showing various relationship statuses

---

## 🛠️ Customization

### Adding New Villains
```sql
INSERT INTO Villains (alias, real_name, evil_level, preferred_partner_type, bio, nemesis)
VALUES ('Your Villain', 'Real Name', 8, 'Partner Type', 'Bio text', 'Nemesis Name');
```

### Adding New Lairs
```sql
INSERT INTO Lairs (villain_id, location_name, security_level, has_lava_moat, has_shark_tank)
VALUES (1, 'Secret Location', 5, TRUE, TRUE);
```

### Creating a Match
```sql
INSERT INTO Matches (villain_id_1, villain_id_2, match_status, compatibility_score)
VALUES (1, 2, 'Active', 85);
```
**Note:** Ensure `villain_id_1 < villain_id_2` to satisfy the constraint!

---

## 🔒 Security Considerations

- All foreign keys use CASCADE delete to maintain referential integrity
- CHECK constraints prevent invalid data entry
- Composite keys prevent duplicate matches
- Indexes improve query performance on large datasets

---

## 📝 File Structure

```
EvilMatch-Database/
├── 01_schema.sql          # Database structure and table definitions
├── 02_sample_data.sql     # Sample villain data and relationships
├── 03_queries.sql         # Useful queries and views
└── README.md              # This documentation file
```

---

## 🤝 Contributing

Want to add more evil features? Consider:
- Additional villain attributes (special powers, weaknesses)
- Message system for villain communication
- Event tracking for villain gatherings
- Rating system for matches
- Lair amenities table

---

## 📜 License

This is a fictional educational database for learning SQL concepts including:
- Database normalization
- Multiple relationship types
- Self-referencing tables
- Composite keys
- Data integrity constraints

---

## 💡 Learning Objectives

This database demonstrates:
1. ✅ Proper table normalization (3NF)
2. ✅ One-to-Many relationships
3. ✅ Many-to-Many self-referencing relationships
4. ✅ Composite primary keys
5. ✅ Foreign key constraints with CASCADE
6. ✅ CHECK constraints for data validation
7. ✅ Strategic indexing for performance
8. ✅ Complex JOIN queries
9. ✅ Aggregate functions and GROUP BY
10. ✅ View creation for common queries

---

**Happy Evil Matching! 💀❤️**
