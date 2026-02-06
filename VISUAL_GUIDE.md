# EVILMATCH DATABASE - VISUAL GUIDE
## Understanding Database Structure Through Diagrams

---

## TABLE OF CONTENTS
1. [Entity Relationship Diagram (ERD)](#erd)
2. [Table Relationships](#relationships)
3. [Data Flow Examples](#dataflow)
4. [Constraint Visualization](#constraints)
5. [Query Execution Flow](#queries)

---

## <a name="erd"></a>1. ENTITY RELATIONSHIP DIAGRAM (ERD)

```
┌─────────────────────────────────────────────────────────────────┐
│                         EVILMATCH DATABASE                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────┐
│      VILLAINS        │  ← Main entity (users of the app)
├──────────────────────┤
│ PK villain_id        │  PK = Primary Key (unique identifier)
│    alias             │  
│    real_name         │
│    evil_level        │  Range: 1-10
│    preferred_partner │
│    join_date         │
│    bio               │
│    nemesis           │
└──────────┬───────────┘
           │
           │ ONE villain has MANY lairs
           │
           ├──────────────────────┐
           │                      │
           ▼                      ▼
┌──────────────────────┐ ┌──────────────────────┐
│       LAIRS          │ │    EVIL_PLANS        │
├──────────────────────┤ ├──────────────────────┤
│ PK lair_id           │ │ PK plan_id           │
│ FK villain_id    ────┼─┤ FK villain_id    ────┤
│    location_name     │ │    plan_name         │
│    security_level    │ │    completion_year   │
│    has_lava_moat     │ │    status            │
│    has_shark_tank    │ │    budget            │
│    square_footage    │ │    difficulty_rating │
└──────────────────────┘ └──────────────────────┘

           │
           │ MANY villains match with MANY villains
           │
           ▼
┌────────────────────────────┐
│        MATCHES             │  ← Junction table (bridge)
├────────────────────────────┤
│ PK villain_id_1        ────┼──┐
│ PK villain_id_2        ────┼──┼─ Both reference Villains table
│    match_date              │  │
│    match_status            │  │
│    compatibility_score     │  │
│    first_date_location     │  │
└────────────────────────────┘  │
     │                           │
     └───────────────────────────┘
         (Self-referencing)

LEGEND:
PK = Primary Key (unique identifier)
FK = Foreign Key (reference to another table)
─── = Relationship line
```

---

## <a name="relationships"></a>2. TABLE RELATIONSHIPS

### ONE-TO-MANY: Villains → Lairs

```
One Villain can have MANY Lairs
Each Lair belongs to ONE Villain

VILLAINS TABLE                      LAIRS TABLE
┌──────────┬─────────────┐         ┌─────────┬────────────┬───────────────┐
│villain_id│   alias     │         │ lair_id │villain_id  │ location_name │
├──────────┼─────────────┤         ├─────────┼────────────┼───────────────┤
│    1     │Dark Overlord│ ◄───┐   │   1     │     1      │ Volcano       │
│    2     │Dr. Freeze   │     └───┤   2     │     1      │ Bunker        │
│    3     │Shadow       │         │   3     │     1      │ Castle        │
└──────────┴─────────────┘         │   4     │     2      │ Ice Palace    │
                                   │   5     │     3      │ Subway        │
                                   └─────────┴────────────┴───────────────┘
                                             ↑
                                     Foreign Key links
                                     to Villains table

Dark Overlord (ID=1) has 3 lairs
Dr. Freeze (ID=2) has 1 lair
Shadow (ID=3) has 1 lair
```

### ONE-TO-MANY: Villains → Evil_Plans

```
One Villain can have MANY Evil Plans
Each Evil Plan belongs to ONE Villain

VILLAINS TABLE                      EVIL_PLANS TABLE
┌──────────┬─────────────┐         ┌─────────┬────────────┬─────────────────┐
│villain_id│   alias     │         │ plan_id │villain_id  │   plan_name     │
├──────────┼─────────────┤         ├─────────┼────────────┼─────────────────┤
│    1     │Dark Overlord│ ◄───┐   │   1     │     1      │ World Domination│
│    2     │Dr. Freeze   │     ├───┤   2     │     1      │ Moon Base       │
│    3     │Shadow       │     │   │   3     │     1      │ Network Shutdown│
└──────────┴─────────────┘     │   │   4     │     2      │ Freeze Oceans   │
                               │   │   5     │     3      │ Infiltrate Gov  │
                               │   └─────────┴────────────┴─────────────────┘
                               │             ↑
                               │     Foreign Key links
                               └─────to Villains table

Dark Overlord (ID=1) has 3 evil plans
Dr. Freeze (ID=2) has 1 evil plan
Shadow (ID=3) has 1 evil plan
```

### MANY-TO-MANY: Villains ↔ Villains (Matches)

```
MANY Villains can match with MANY Villains
Requires a JUNCTION TABLE (Matches)

VILLAINS TABLE
┌──────────┬─────────────┐
│villain_id│   alias     │
├──────────┼─────────────┤
│    1     │Dark Overlord│ ◄─────┐
│    2     │Dr. Freeze   │ ◄───┐ │
│    3     │Shadow       │ ◄─┐ │ │
│    4     │Count Chaos  │ ◄─│─│─│─┐
└──────────┴─────────────┘   │ │ │ │
                              │ │ │ │
         MATCHES TABLE (Junction)
         ┌──────────────┬──────────────┬──────────┐
         │ villain_id_1 │ villain_id_2 │  status  │
         ├──────────────┼──────────────┼──────────┤
         │      1       │      2       │  Active  │──┐
         │      1       │      4       │  Active  │  │
         │      2       │      3       │  Pending │  │
         │      3       │      4       │  Ghosted │  │
         └──────────────┴──────────────┴──────────┘  │
                  ↑             ↑                     │
         Both are Foreign Keys to Villains table     │
                                                      │
INTERPRETATION:                                       │
─────────────────────────────────────────────────────┘
Villain 1 (Dark Overlord) matched with:
  - Villain 2 (Dr. Freeze) - Active
  - Villain 4 (Count Chaos) - Active

Villain 2 (Dr. Freeze) matched with:
  - Villain 1 (Dark Overlord) - Active
  - Villain 3 (Shadow) - Pending

Villain 3 (Shadow) matched with:
  - Villain 2 (Dr. Freeze) - Pending
  - Villain 4 (Count Chaos) - Ghosted

Villain 4 (Count Chaos) matched with:
  - Villain 1 (Dark Overlord) - Active
  - Villain 3 (Shadow) - Ghosted
```

---

## <a name="dataflow"></a>3. DATA FLOW EXAMPLES

### Example 1: Adding a New Villain with Lairs

```
STEP 1: Insert Villain
────────────────────────────────────────────────
INSERT INTO Villains (alias, evil_level) 
VALUES ('New Villain', 8);

VILLAINS TABLE
┌──────────┬─────────────┬────────────┐
│villain_id│   alias     │ evil_level │
├──────────┼─────────────┼────────────┤
│    1     │Dark Overlord│     9      │
│    2     │Dr. Freeze   │     7      │
│    5     │New Villain  │     8      │ ← AUTO_INCREMENT assigns ID=5
└──────────┴─────────────┴────────────┘


STEP 2: Insert Lairs for New Villain
────────────────────────────────────────────────
INSERT INTO Lairs (villain_id, location_name) 
VALUES (5, 'Secret Base');

LAIRS TABLE
┌─────────┬────────────┬───────────────┐
│ lair_id │villain_id  │ location_name │
├─────────┼────────────┼───────────────┤
│   1     │     1      │ Volcano       │
│   2     │     1      │ Bunker        │
│   8     │     5      │ Secret Base   │ ← Links to villain_id=5
└─────────┴────────────┴───────────────┘
                ↑
         Foreign Key constraint ensures
         villain_id=5 EXISTS in Villains
```

### Example 2: Creating a Match

```
STEP 1: Check that both villains exist
────────────────────────────────────────────────
Villain 1 exists? ✓
Villain 2 exists? ✓


STEP 2: Insert Match
────────────────────────────────────────────────
INSERT INTO Matches (villain_id_1, villain_id_2, match_status) 
VALUES (1, 2, 'Active');

MATCHES TABLE
┌──────────────┬──────────────┬──────────┐
│ villain_id_1 │ villain_id_2 │  status  │
├──────────────┼──────────────┼──────────┤
│      1       │      2       │  Active  │ ← New match created
└──────────────┴──────────────┴──────────┘
       ↑              ↑
       │              │
       Both must exist in Villains table
       (Foreign Key constraint)


IMPORTANT: Order matters!
────────────────────────────────────────────────
We have a CHECK constraint: villain_id_1 < villain_id_2

✓ VALID:   (1, 2) - ID 1 is less than ID 2
✗ INVALID: (2, 1) - Would violate constraint
✗ INVALID: (1, 1) - Villain can't match themselves
```

### Example 3: Deleting a Villain (CASCADE effect)

```
BEFORE DELETE:
────────────────────────────────────────────────

VILLAINS                  LAIRS                    EVIL_PLANS
┌──────────┐             ┌──────────┐             ┌──────────┐
│ ID=1     │◄────────────│ ID=1, V=1│             │ ID=1, V=1│
│ Dark     │◄────────────│ ID=2, V=1│◄────────────│ ID=2, V=1│
│ Overlord │             └──────────┘             └──────────┘
└──────────┘
     ▲
     │
MATCHES
┌──────────────┐
│ V1=1, V2=2   │
└──────────────┘


EXECUTE:
────────────────────────────────────────────────
DELETE FROM Villains WHERE villain_id = 1;


AFTER DELETE (CASCADE):
────────────────────────────────────────────────

VILLAINS                  LAIRS                    EVIL_PLANS
┌──────────┐             ┌──────────┐             ┌──────────┐
│ (empty)  │             │ (empty)  │             │ (empty)  │
└──────────┘             └──────────┘             └──────────┘

MATCHES
┌──────────────┐
│ (empty)      │
└──────────────┘

ALL related records automatically deleted because of:
FOREIGN KEY ... ON DELETE CASCADE
```

---

## <a name="constraints"></a>4. CONSTRAINT VISUALIZATION

### PRIMARY KEY Constraint

```
Purpose: Uniquely identify each row

VILLAINS TABLE
┌──────────┬─────────────┬────────────┐
│villain_id│   alias     │ evil_level │
│   (PK)   │             │            │
├══════════┼─────────────┼────────────┤  ← PK must be unique
│    1     │Dark Overlord│     9      │
│    2     │Dr. Freeze   │     7      │
│    3     │Shadow       │     8      │
└──────────┴─────────────┴────────────┘

✓ Each villain_id is different
✓ No NULL values allowed
✓ Can reference this from other tables
```

### FOREIGN KEY Constraint

```
Purpose: Ensure referenced data exists

VILLAINS                      LAIRS
┌──────────┐                 ┌─────────┬────────────┐
│villain_id│                 │ lair_id │villain_id  │
│   (PK)   │                 │  (PK)   │   (FK)     │
├══════════┤                 ├═════════┼════════════┤
│    1     │◄────────────────│   1     │     1      │ ✓ Valid: 1 exists
│    2     │◄────────────────│   2     │     1      │ ✓ Valid: 1 exists
│    3     │                 │   3     │     2      │ ✓ Valid: 2 exists
└──────────┘                 │   4     │    99      │ ✗ INVALID: 99 doesn't exist
                             └─────────┴────────────┘
                                           ↑
                               Foreign Key constraint prevents this!
```

### COMPOSITE PRIMARY KEY

```
Purpose: Combination must be unique (not individual columns)

MATCHES TABLE
┌──────────────┬──────────────┬──────────┐
│ villain_id_1 │ villain_id_2 │  status  │
│  (PK part 1) │  (PK part 2) │          │
├══════════════┼══════════════┼══════════┤
│      1       │      2       │  Active  │ ✓ Combination (1,2) is unique
│      1       │      3       │  Pending │ ✓ Combination (1,3) is unique
│      2       │      3       │  Active  │ ✓ Combination (2,3) is unique
│      1       │      2       │  Ghosted │ ✗ DUPLICATE (1,2) - NOT ALLOWED
└──────────────┴──────────────┴──────────┘

Notice:
- villain_id_1 = 1 appears twice ✓ OK
- villain_id_2 = 2 appears twice ✓ OK
- But combination (1,2) can only appear once!
```

### CHECK Constraint

```
Purpose: Validate data before inserting

VILLAINS TABLE
┌──────────┬─────────────┬────────────┐
│villain_id│   alias     │ evil_level │
│          │             │ CHECK 1-10 │
├──────────┼─────────────┼════════════┤
│    1     │Dark Overlord│     9      │ ✓ 9 is between 1-10
│    2     │Dr. Freeze   │     7      │ ✓ 7 is between 1-10
│    3     │Shadow       │    15      │ ✗ REJECTED: 15 > 10
│    4     │New Villain  │     0      │ ✗ REJECTED: 0 < 1
└──────────┴─────────────┴────────────┘

CHECK (evil_level BETWEEN 1 AND 10)
       └──────────┬──────────┘
                  │
    Validates BEFORE inserting
```

### UNIQUE Constraint

```
Purpose: No duplicates allowed

VILLAINS TABLE
┌──────────┬─────────────────┬────────────┐
│villain_id│   alias         │ evil_level │
│   (PK)   │  (UNIQUE)       │            │
├══════════┼═════════════════┼════════════┤
│    1     │ Dark Overlord   │     9      │
│    2     │ Dr. Freeze      │     7      │
│    3     │ Shadow          │     8      │
│    4     │ Dark Overlord   │     6      │ ✗ DUPLICATE alias!
└──────────┴─────────────────┴────────────┘
                  ↑
         UNIQUE constraint prevents this!

Note: UNIQUE allows NULL values (unlike PRIMARY KEY)
```

### NOT NULL Constraint

```
Purpose: Value must be provided

VILLAINS TABLE
┌──────────┬─────────────┬────────────┐
│villain_id│   alias     │  real_name │
│   (PK)   │ (NOT NULL)  │  (nullable)│
├══════════┼═════════════┼════════════┤
│    1     │Dark Overlord│  Derek     │ ✓ All values present
│    2     │ Dr. Freeze  │   NULL     │ ✓ real_name can be NULL
│    3     │    NULL     │  Sarah     │ ✗ alias cannot be NULL
└──────────┴─────────────┴────────────┘
                 ↑
      NOT NULL constraint prevents this!
```

---

## <a name="queries"></a>5. QUERY EXECUTION FLOW

### Simple SELECT with WHERE

```
Query:
SELECT alias, evil_level 
FROM Villains 
WHERE evil_level >= 8;

STEP 1: FROM - Get table
────────────────────────────────────────────────
VILLAINS TABLE (all rows)
┌──────────┬─────────────┬────────────┐
│villain_id│   alias     │ evil_level │
├──────────┼─────────────┼────────────┤
│    1     │Dark Overlord│     9      │
│    2     │Dr. Freeze   │     7      │
│    3     │Shadow       │     8      │
│    4     │Count Chaos  │    10      │
│    5     │The Riddler  │     6      │
└──────────┴─────────────┴────────────┘


STEP 2: WHERE - Filter rows
────────────────────────────────────────────────
evil_level >= 8?
┌──────────┬─────────────┬────────────┬────────┐
│villain_id│   alias     │ evil_level │ Keep?  │
├──────────┼─────────────┼────────────┼────────┤
│    1     │Dark Overlord│     9      │   ✓    │ ← 9 >= 8
│    2     │Dr. Freeze   │     7      │   ✗    │ ← 7 < 8
│    3     │Shadow       │     8      │   ✓    │ ← 8 >= 8
│    4     │Count Chaos  │    10      │   ✓    │ ← 10 >= 8
│    5     │The Riddler  │     6      │   ✗    │ ← 6 < 8
└──────────┴─────────────┴────────────┴────────┘


STEP 3: SELECT - Choose columns
────────────────────────────────────────────────
RESULT (only alias and evil_level columns)
┌─────────────┬────────────┐
│   alias     │ evil_level │
├─────────────┼────────────┤
│Dark Overlord│     9      │
│Shadow       │     8      │
│Count Chaos  │    10      │
└─────────────┴────────────┘
```

### JOIN Query

```
Query:
SELECT v.alias, l.location_name
FROM Villains v
JOIN Lairs l ON v.villain_id = l.villain_id;

STEP 1: FROM Villains
────────────────────────────────────────────────
VILLAINS (v)
┌──────────┬─────────────┐
│villain_id│   alias     │
├──────────┼─────────────┤
│    1     │Dark Overlord│
│    2     │Dr. Freeze   │
│    3     │Shadow       │
└──────────┴─────────────┘


STEP 2: JOIN Lairs
────────────────────────────────────────────────
LAIRS (l)
┌─────────┬────────────┬───────────────┐
│ lair_id │villain_id  │ location_name │
├─────────┼────────────┼───────────────┤
│   1     │     1      │ Volcano       │
│   2     │     1      │ Bunker        │
│   3     │     2      │ Ice Palace    │
│   4     │     3      │ Subway        │
└─────────┴────────────┴───────────────┘


STEP 3: Match ON condition (v.villain_id = l.villain_id)
────────────────────────────────────────────────
COMBINED (matched rows)
┌──────────┬─────────────┬────────────┬───────────────┐
│villain_id│   alias     │villain_id  │ location_name │
│    (v)   │     (v)     │    (l)     │      (l)      │
├──────────┼─────────────┼────────────┼───────────────┤
│    1     │Dark Overlord│     1      │ Volcano       │ ✓ 1=1 match
│    1     │Dark Overlord│     1      │ Bunker        │ ✓ 1=1 match
│    2     │Dr. Freeze   │     2      │ Ice Palace    │ ✓ 2=2 match
│    3     │Shadow       │     3      │ Subway        │ ✓ 3=3 match
└──────────┴─────────────┴────────────┴───────────────┘


STEP 4: SELECT specified columns
────────────────────────────────────────────────
RESULT
┌─────────────┬───────────────┐
│   alias     │ location_name │
├─────────────┼───────────────┤
│Dark Overlord│ Volcano       │
│Dark Overlord│ Bunker        │
│Dr. Freeze   │ Ice Palace    │
│Shadow       │ Subway        │
└─────────────┴───────────────┘
```

### GROUP BY with COUNT

```
Query:
SELECT v.alias, COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias;

STEP 1: FROM + LEFT JOIN (all villains, matched lairs)
────────────────────────────────────────────────
COMBINED
┌──────────┬─────────────┬─────────┐
│villain_id│   alias     │ lair_id │
│    (v)   │     (v)     │   (l)   │
├──────────┼─────────────┼─────────┤
│    1     │Dark Overlord│    1    │
│    1     │Dark Overlord│    2    │
│    2     │Dr. Freeze   │    3    │
│    3     │Shadow       │    4    │
│    4     │New Villain  │  NULL   │ ← No lairs (LEFT JOIN includes)
└──────────┴─────────────┴─────────┘


STEP 2: GROUP BY villain_id and alias
────────────────────────────────────────────────
Group 1: villain_id=1, alias='Dark Overlord'
  ┌─────────┐
  │ lair_id │
  ├─────────┤
  │    1    │
  │    2    │
  └─────────┘

Group 2: villain_id=2, alias='Dr. Freeze'
  ┌─────────┐
  │ lair_id │
  ├─────────┤
  │    3    │
  └─────────┘

Group 3: villain_id=3, alias='Shadow'
  ┌─────────┐
  │ lair_id │
  ├─────────┤
  │    4    │
  └─────────┘

Group 4: villain_id=4, alias='New Villain'
  ┌─────────┐
  │ lair_id │
  ├─────────┤
  │  NULL   │
  └─────────┘


STEP 3: COUNT(l.lair_id) for each group
────────────────────────────────────────────────
Group 1: COUNT(1, 2) = 2
Group 2: COUNT(3) = 1
Group 3: COUNT(4) = 1
Group 4: COUNT(NULL) = 0  ← NULL not counted


STEP 4: SELECT result
────────────────────────────────────────────────
RESULT
┌─────────────┬────────────┐
│   alias     │ lair_count │
├─────────────┼────────────┤
│Dark Overlord│     2      │
│Dr. Freeze   │     1      │
│Shadow       │     1      │
│New Villain  │     0      │
└─────────────┴────────────┘
```

---

## KEY TAKEAWAYS

### 1. Tables store data in rows and columns
```
Think of tables as Excel spreadsheets
```

### 2. Primary Keys uniquely identify rows
```
Like a Social Security Number for each record
```

### 3. Foreign Keys create relationships
```
Like references/pointers to other tables
```

### 4. One-to-Many = FK in "Many" table
```
One parent → many children
```

### 5. Many-to-Many = Junction table needed
```
Bridge table with two FKs
```

### 6. Constraints ensure data quality
```
Prevent bad data from entering
```

### 7. JOINs combine tables
```
Match rows based on related columns
```

### 8. GROUP BY aggregates data
```
Collapse multiple rows into summaries
```

---

## PRACTICE EXERCISES

Try drawing these diagrams yourself:

1. **Draw the ERD for a library system**
   - Books table
   - Authors table
   - Borrowers table
   - What relationships exist?

2. **Visualize a shopping system**
   - Products table
   - Customers table
   - Orders table
   - Order_Items junction table

3. **Trace a query execution**
   - Draw each step of a JOIN query
   - Show what data flows through

Happy learning! 💀❤️📊
