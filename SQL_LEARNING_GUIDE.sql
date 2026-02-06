-- ============================================================================
-- EVILMATCH DATABASE - COMPLETE LEARNING GUIDE
-- Understanding Every SQL Concept Used
-- ============================================================================

/*
================================================================================
TABLE OF CONTENTS
================================================================================

PART 1: FOUNDATIONAL CONCEPTS
    1.1 - Database Tables and Structure
    1.2 - Data Types Explained
    1.3 - Primary Keys
    1.4 - Auto Increment

PART 2: DATA INTEGRITY
    2.1 - NOT NULL Constraints
    2.2 - UNIQUE Constraints
    2.3 - DEFAULT Values
    2.4 - CHECK Constraints

PART 3: RELATIONSHIPS
    3.1 - Foreign Keys
    3.2 - One-to-Many Relationships
    3.3 - Many-to-Many Relationships
    3.4 - Self-Referencing Tables
    3.5 - CASCADE Operations

PART 4: PERFORMANCE OPTIMIZATION
    4.1 - Indexes
    4.2 - Composite Keys
    4.3 - Query Optimization

PART 5: PRACTICAL QUERIES
    5.1 - SELECT Statements
    5.2 - JOIN Operations
    5.3 - Aggregate Functions
    5.4 - GROUP BY and HAVING
    5.5 - Subqueries
    5.6 - Views

================================================================================
*/


-- ============================================================================
-- PART 1: FOUNDATIONAL CONCEPTS
-- ============================================================================

/*
--------------------------------------------------------------------------------
1.1 - DATABASE TABLES AND STRUCTURE
--------------------------------------------------------------------------------

What is a table?
    A table is like a spreadsheet in a database. It has:
    - Columns (fields) that define what type of data can be stored
    - Rows (records) that contain the actual data

Example:
    Imagine a simple table for villains:
    
    | villain_id | alias           | evil_level |
    |------------|-----------------|------------|
    | 1          | Dark Overlord   | 9          |
    | 2          | Dr. Freeze      | 7          |
    
    - Columns: villain_id, alias, evil_level
    - Rows: The actual villain data

Basic CREATE TABLE syntax:
*/

CREATE TABLE example_table (
    column_name DATA_TYPE CONSTRAINTS,
    another_column DATA_TYPE CONSTRAINTS
);

/*
--------------------------------------------------------------------------------
1.2 - DATA TYPES EXPLAINED
--------------------------------------------------------------------------------

MySQL has many data types. Here are the ones we use:

INT (Integer)
    - Stores whole numbers: -2,147,483,648 to 2,147,483,647
    - Perfect for: IDs, counts, years, levels
    - Examples: villain_id, evil_level, security_level
*/

CREATE TABLE example_int (
    id INT,                    -- Can be any whole number
    age INT,                   -- 25, 30, 45
    year INT                   -- 2025, 2030
);

/*
VARCHAR(size) - Variable Character
    - Stores text up to 'size' characters
    - Uses only the space it needs
    - Examples: names, addresses, descriptions
*/

CREATE TABLE example_varchar (
    alias VARCHAR(100),        -- Up to 100 characters
    location VARCHAR(150),     -- Up to 150 characters
    status VARCHAR(20)         -- Up to 20 characters
);

-- Why different sizes?
-- alias VARCHAR(100)    - Villain names won't be super long
-- location VARCHAR(150) - Addresses can be longer
-- status VARCHAR(20)    - Status is usually short: "Active", "Pending"

/*
TEXT
    - Stores large amounts of text (up to 65,535 characters)
    - Perfect for: descriptions, bios, long content
*/

CREATE TABLE example_text (
    bio TEXT,                  -- Long biography
    description TEXT           -- Detailed description
);

/*
DATE
    - Stores dates in format: YYYY-MM-DD
    - Example: 2025-02-06
*/

CREATE TABLE example_date (
    join_date DATE,            -- When they joined
    match_date DATE            -- When they matched
);

/*
BOOLEAN
    - Stores TRUE or FALSE (1 or 0)
    - Perfect for: yes/no questions
*/

CREATE TABLE example_boolean (
    has_lava_moat BOOLEAN,     -- TRUE or FALSE
    has_shark_tank BOOLEAN     -- TRUE or FALSE
);

/*
DECIMAL(total_digits, decimal_places)
    - Stores precise decimal numbers
    - DECIMAL(10, 2) means: 10 total digits, 2 after decimal
    - Example: 12345678.90 (8 digits before, 2 after = 10 total)
*/

CREATE TABLE example_decimal (
    budget_in_millions DECIMAL(10, 2)  -- 99999999.99 max
);

/*
--------------------------------------------------------------------------------
1.3 - PRIMARY KEYS
--------------------------------------------------------------------------------

What is a PRIMARY KEY?
    - A column (or combination of columns) that UNIQUELY identifies each row
    - Must be UNIQUE - no two rows can have the same primary key
    - Cannot be NULL - must have a value
    - Each table should have ONE primary key

Why do we need it?
    - To identify each record uniquely
    - To create relationships between tables
    - To ensure data integrity

Example:
*/

CREATE TABLE villains_example (
    villain_id INT PRIMARY KEY,    -- This uniquely identifies each villain
    alias VARCHAR(100)
);

-- Now we can reference villain_id to identify specific villains:
-- villain_id = 1 → The Dark Overlord
-- villain_id = 2 → Dr. Freeze-Frame

/*
--------------------------------------------------------------------------------
1.4 - AUTO INCREMENT
--------------------------------------------------------------------------------

What is AUTO_INCREMENT?
    - Automatically generates a unique number for each new row
    - Usually starts at 1 and increases by 1 each time
    - Perfect for ID columns

Without AUTO_INCREMENT (manual):
*/
INSERT INTO villains_example (villain_id, alias) VALUES (1, 'Dark Overlord');
INSERT INTO villains_example (villain_id, alias) VALUES (2, 'Dr. Freeze');
-- You have to remember what number to use!

/*
With AUTO_INCREMENT (automatic):
*/
CREATE TABLE villains_auto (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100)
);

INSERT INTO villains_auto (alias) VALUES ('Dark Overlord');
-- villain_id becomes 1 automatically!
INSERT INTO villains_auto (alias) VALUES ('Dr. Freeze');
-- villain_id becomes 2 automatically!


-- ============================================================================
-- PART 2: DATA INTEGRITY
-- ============================================================================

/*
--------------------------------------------------------------------------------
2.1 - NOT NULL CONSTRAINTS
--------------------------------------------------------------------------------

What is NOT NULL?
    - Forces a column to ALWAYS have a value
    - Cannot insert a row without providing this data
    - Ensures critical data is never missing

Example:
*/

CREATE TABLE villains_not_null (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL,        -- MUST provide an alias
    real_name VARCHAR(100)              -- Can be NULL (optional)
);

-- This works:
INSERT INTO villains_not_null (alias, real_name) 
VALUES ('Dark Overlord', 'Derek Johnson');

-- This works too (real_name can be NULL):
INSERT INTO villains_not_null (alias) 
VALUES ('Shadow Serpent');

-- This FAILS (alias is required):
-- INSERT INTO villains_not_null (real_name) VALUES ('John Doe');
-- Error: Field 'alias' doesn't have a default value

/*
--------------------------------------------------------------------------------
2.2 - UNIQUE CONSTRAINTS
--------------------------------------------------------------------------------

What is UNIQUE?
    - Ensures all values in a column are different
    - Prevents duplicate entries
    - Can be NULL (unless also marked NOT NULL)

Example:
*/

CREATE TABLE villains_unique (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL UNIQUE  -- No two villains can have same alias
);

-- This works:
INSERT INTO villains_unique (alias) VALUES ('Dark Overlord');

-- This FAILS (duplicate alias):
-- INSERT INTO villains_unique (alias) VALUES ('Dark Overlord');
-- Error: Duplicate entry 'Dark Overlord' for key 'alias'

/*
Real-world analogy:
    - PRIMARY KEY = Social Security Number (unique identifier)
    - UNIQUE = Email address (must be unique, but not the main identifier)
    - NOT NULL + UNIQUE = Username (required and must be unique)

--------------------------------------------------------------------------------
2.3 - DEFAULT VALUES
--------------------------------------------------------------------------------

What is DEFAULT?
    - Provides an automatic value if none is specified
    - Saves time and ensures consistency

Example:
*/

CREATE TABLE villains_default (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL,
    evil_level INT DEFAULT 1,           -- Starts at level 1 if not specified
    join_date DATE DEFAULT (CURRENT_DATE)  -- Automatically uses today's date
);

-- If you don't specify evil_level or join_date:
INSERT INTO villains_default (alias) VALUES ('Newbie Villain');
-- evil_level becomes 1
-- join_date becomes today's date

-- You can override defaults:
INSERT INTO villains_default (alias, evil_level, join_date) 
VALUES ('Pro Villain', 9, '2025-01-01');

/*
--------------------------------------------------------------------------------
2.4 - CHECK CONSTRAINTS
--------------------------------------------------------------------------------

What is CHECK?
    - Validates data before inserting/updating
    - Ensures data meets specific conditions
    - Prevents invalid data

Example:
*/

CREATE TABLE villains_check (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL,
    evil_level INT CHECK (evil_level BETWEEN 1 AND 10)  -- Must be 1-10
);

-- This works:
INSERT INTO villains_check (alias, evil_level) VALUES ('Dark Overlord', 9);

-- This FAILS (evil_level too high):
-- INSERT INTO villains_check (alias, evil_level) VALUES ('Super Villain', 15);
-- Error: Check constraint is violated

/*
CHECK with multiple conditions:
*/

CREATE TABLE evil_plans_check (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(200) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('In Progress', 'Completed', 'Failed', 'On Hold'))
);

-- Only these status values are allowed:
-- 'In Progress', 'Completed', 'Failed', 'On Hold'

-- This works:
INSERT INTO evil_plans_check (plan_name, status) 
VALUES ('World Domination', 'In Progress');

-- This FAILS:
-- INSERT INTO evil_plans_check (plan_name, status) 
-- VALUES ('Moon Theft', 'Thinking About It');
-- Error: Check constraint is violated


-- ============================================================================
-- PART 3: RELATIONSHIPS
-- ============================================================================

/*
--------------------------------------------------------------------------------
3.1 - FOREIGN KEYS
--------------------------------------------------------------------------------

What is a FOREIGN KEY?
    - A column that references the PRIMARY KEY of another table
    - Creates a relationship between two tables
    - Ensures referential integrity (referenced data must exist)

Example: Lairs belong to Villains
*/

-- First, we need a Villains table:
CREATE TABLE villains_fk (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL
);

-- Now, Lairs table references Villains:
CREATE TABLE lairs_fk (
    lair_id INT PRIMARY KEY AUTO_INCREMENT,
    villain_id INT NOT NULL,                    -- This will be the foreign key
    location_name VARCHAR(150) NOT NULL,
    
    FOREIGN KEY (villain_id) REFERENCES villains_fk(villain_id)
    --          ^                                  ^
    --          Column in THIS table               Column in OTHER table
);

/*
What does this mean?
    - Every lair MUST belong to a villain that EXISTS in the villains table
    - You cannot create a lair for villain_id = 999 if that villain doesn't exist

Example:
*/

-- Add a villain first:
INSERT INTO villains_fk (alias) VALUES ('Dark Overlord');
-- This creates villain_id = 1

-- Now add a lair for this villain:
INSERT INTO lairs_fk (villain_id, location_name) 
VALUES (1, 'Volcano Fortress');
-- This works because villain_id = 1 exists!

-- This FAILS (villain_id = 999 doesn't exist):
-- INSERT INTO lairs_fk (villain_id, location_name) 
-- VALUES (999, 'Secret Base');
-- Error: Cannot add foreign key constraint

/*
--------------------------------------------------------------------------------
3.2 - ONE-TO-MANY RELATIONSHIPS
--------------------------------------------------------------------------------

What is One-to-Many?
    - ONE record in Table A can relate to MANY records in Table B
    - But each record in Table B relates to only ONE record in Table A

Example: One Villain → Many Lairs

    Villain Table:
    | villain_id | alias         |
    |------------|---------------|
    | 1          | Dark Overlord |
    | 2          | Dr. Freeze    |
    
    Lairs Table:
    | lair_id | villain_id | location_name  |
    |---------|------------|----------------|
    | 1       | 1          | Volcano        |  ← belongs to Dark Overlord
    | 2       | 1          | Bunker         |  ← belongs to Dark Overlord
    | 3       | 2          | Ice Palace     |  ← belongs to Dr. Freeze
    
    Dark Overlord (villain_id=1) has TWO lairs
    Dr. Freeze (villain_id=2) has ONE lair
    
How it's implemented:
    - The "Many" side (Lairs) has a foreign key pointing to the "One" side (Villains)
    - villain_id in Lairs table references villain_id in Villains table
*/

CREATE TABLE villains_one_to_many (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL
);

CREATE TABLE lairs_one_to_many (
    lair_id INT PRIMARY KEY AUTO_INCREMENT,
    villain_id INT NOT NULL,
    location_name VARCHAR(150),
    FOREIGN KEY (villain_id) REFERENCES villains_one_to_many(villain_id)
);

-- One villain can have many lairs:
INSERT INTO villains_one_to_many (alias) VALUES ('Dark Overlord');
INSERT INTO lairs_one_to_many (villain_id, location_name) VALUES (1, 'Volcano');
INSERT INTO lairs_one_to_many (villain_id, location_name) VALUES (1, 'Bunker');
INSERT INTO lairs_one_to_many (villain_id, location_name) VALUES (1, 'Castle');

/*
Other One-to-Many examples in our database:
    - One Villain → Many Evil Plans
    - One Author → Many Books
    - One Customer → Many Orders
    - One School → Many Students

--------------------------------------------------------------------------------
3.3 - MANY-TO-MANY RELATIONSHIPS
--------------------------------------------------------------------------------

What is Many-to-Many?
    - MANY records in Table A can relate to MANY records in Table B
    - Requires a "junction table" (also called "bridge table" or "linking table")

Example: Villains ↔ Villains (Dating Matches)

    Think about it:
    - One villain can match with MANY other villains
    - Each of those villains can also match with MANY villains
    
    Dark Overlord matches with: Dr. Freeze, Shadow Serpent, Count Chaos
    Dr. Freeze matches with: Dark Overlord, Toxic Avenger
    
How it's implemented:
    - Create a junction table that connects the two tables
    - Junction table has TWO foreign keys
*/

CREATE TABLE villains_many_to_many (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL
);

-- Junction table for matches:
CREATE TABLE matches_many_to_many (
    villain_id_1 INT NOT NULL,
    villain_id_2 INT NOT NULL,
    match_date DATE DEFAULT (CURRENT_DATE),
    
    PRIMARY KEY (villain_id_1, villain_id_2),  -- Composite key (explained later)
    FOREIGN KEY (villain_id_1) REFERENCES villains_many_to_many(villain_id),
    FOREIGN KEY (villain_id_2) REFERENCES villains_many_to_many(villain_id)
);

/*
Example data:

    Villains:
    | villain_id | alias         |
    |------------|---------------|
    | 1          | Dark Overlord |
    | 2          | Dr. Freeze    |
    | 3          | Shadow        |
    
    Matches:
    | villain_id_1 | villain_id_2 |
    |--------------|--------------|
    | 1            | 2            |  ← Dark Overlord matches Dr. Freeze
    | 1            | 3            |  ← Dark Overlord matches Shadow
    | 2            | 3            |  ← Dr. Freeze matches Shadow
    
    Dark Overlord (1) is matched with: 2 and 3
    Dr. Freeze (2) is matched with: 1 and 3
    Shadow (3) is matched with: 1 and 2

Other Many-to-Many examples:
    - Students ↔ Classes (students take many classes, classes have many students)
    - Actors ↔ Movies (actors in many movies, movies have many actors)
    - Products ↔ Orders (via order_items table)

--------------------------------------------------------------------------------
3.4 - SELF-REFERENCING TABLES
--------------------------------------------------------------------------------

What is Self-Referencing?
    - When a table has a foreign key that references its OWN primary key
    - Used when records in a table relate to other records in the SAME table

The Matches table is self-referencing:
    - villain_id_1 references Villains table
    - villain_id_2 ALSO references Villains table
    - Both villains come from the SAME table

Why is this useful?
    - Employee → Manager (both are employees)
    - Product → Related Products
    - Social Network Friends (users connecting to users)
    - Dating App Matches (villains matching with villains)
*/

CREATE TABLE employees_self_ref (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    manager_id INT,  -- References another employee
    FOREIGN KEY (manager_id) REFERENCES employees_self_ref(employee_id)
);

-- Example data:
INSERT INTO employees_self_ref (name, manager_id) VALUES ('CEO', NULL);
-- employee_id=1, manager_id=NULL (CEO has no manager)

INSERT INTO employees_self_ref (name, manager_id) VALUES ('Manager', 1);
-- employee_id=2, manager_id=1 (Manager reports to CEO)

INSERT INTO employees_self_ref (name, manager_id) VALUES ('Employee', 2);
-- employee_id=3, manager_id=2 (Employee reports to Manager)

/*
--------------------------------------------------------------------------------
3.5 - CASCADE OPERATIONS
--------------------------------------------------------------------------------

What is CASCADE?
    - Defines what happens when a referenced row is deleted or updated
    - Automatically performs actions on related rows

ON DELETE CASCADE
    - When a parent row is deleted, automatically delete child rows

ON UPDATE CASCADE
    - When a parent key is updated, automatically update child foreign keys
*/

CREATE TABLE villains_cascade (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL
);

CREATE TABLE lairs_cascade (
    lair_id INT PRIMARY KEY AUTO_INCREMENT,
    villain_id INT NOT NULL,
    location_name VARCHAR(150),
    
    FOREIGN KEY (villain_id) REFERENCES villains_cascade(villain_id)
        ON DELETE CASCADE   -- If villain deleted, delete their lairs too
        ON UPDATE CASCADE   -- If villain_id changes, update lairs too
);

/*
Example:
*/

-- Add villain and lairs:
INSERT INTO villains_cascade (alias) VALUES ('Dark Overlord');  -- villain_id=1
INSERT INTO lairs_cascade (villain_id, location_name) VALUES (1, 'Volcano');
INSERT INTO lairs_cascade (villain_id, location_name) VALUES (1, 'Bunker');

-- Now delete the villain:
DELETE FROM villains_cascade WHERE villain_id = 1;

-- What happens?
-- The villain is deleted
-- BOTH lairs are AUTOMATICALLY deleted (CASCADE)

/*
Other CASCADE options:

ON DELETE RESTRICT
    - Prevents deletion if child rows exist
    - "You can't delete this villain, they have lairs!"

ON DELETE SET NULL
    - Sets foreign key to NULL when parent is deleted
    - Lairs would remain but villain_id becomes NULL

ON DELETE NO ACTION
    - Similar to RESTRICT
    - Checks constraint at end of statement
*/


-- ============================================================================
-- PART 4: PERFORMANCE OPTIMIZATION
-- ============================================================================

/*
--------------------------------------------------------------------------------
4.1 - INDEXES
--------------------------------------------------------------------------------

What is an INDEX?
    - A data structure that makes searching faster
    - Like an index in a book - helps you find information quickly
    - Trade-off: Faster reads, slightly slower writes

Without an index:
    - Database must scan EVERY row to find matches
    - SELECT * FROM villains WHERE alias = 'Dark Overlord'
    - Checks row 1, row 2, row 3... until found (SLOW for large tables)

With an index:
    - Database uses the index to jump directly to the right rows
    - Much faster! (FAST even for millions of rows)

When to use indexes:
    ✓ Columns frequently used in WHERE clauses
    ✓ Columns used in JOIN operations
    ✓ Columns used in ORDER BY
    ✗ Small tables (not worth it)
    ✗ Columns that change frequently
*/

CREATE TABLE villains_indexed (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL,
    evil_level INT,
    
    INDEX idx_alias (alias),           -- Index on alias
    INDEX idx_evil_level (evil_level)  -- Index on evil_level
);

-- Now this query is super fast:
-- SELECT * FROM villains_indexed WHERE alias = 'Dark Overlord';

/*
Types of indexes in our database:

1. Primary Key Index (automatic)
   - Every PRIMARY KEY automatically gets an index

2. Foreign Key Index (we add manually)
   INDEX idx_villain_id (villain_id)
   - Speeds up JOIN operations

3. Single Column Index
   INDEX idx_alias (alias)
   - Speeds up searches on that column

--------------------------------------------------------------------------------
4.2 - COMPOSITE KEYS
--------------------------------------------------------------------------------

What is a COMPOSITE KEY?
    - A primary key made from TWO (or more) columns
    - The COMBINATION must be unique (individual columns can repeat)

Example: Matches table
*/

CREATE TABLE matches_composite (
    villain_id_1 INT NOT NULL,
    villain_id_2 INT NOT NULL,
    match_date DATE DEFAULT (CURRENT_DATE),
    
    PRIMARY KEY (villain_id_1, villain_id_2)
    --          ^combination of both columns must be unique
);

/*
What does this mean?

    Valid data:
    | villain_id_1 | villain_id_2 |
    |--------------|--------------|
    | 1            | 2            | ✓ OK
    | 1            | 3            | ✓ OK (villain_id_1 repeats, but combination is unique)
    | 2            | 3            | ✓ OK
    
    Invalid data:
    | villain_id_1 | villain_id_2 |
    |--------------|--------------|
    | 1            | 2            | 
    | 1            | 2            | ✗ DUPLICATE - same combination!

Why use composite keys?
    - Perfect for junction tables in many-to-many relationships
    - Ensures no duplicate matches
    - More efficient than adding a separate ID column

--------------------------------------------------------------------------------
4.3 - QUERY OPTIMIZATION
--------------------------------------------------------------------------------

Optimization techniques we used:

1. INDEXES on frequently queried columns
   - alias, evil_level, status
   
2. FOREIGN KEY INDEXES
   - Speeds up JOIN operations
   
3. Proper data types
   - VARCHAR(20) instead of TEXT for short strings
   - INT instead of VARCHAR for numbers
   
4. NOT NULL where appropriate
   - Allows database to make optimizations
*/


-- ============================================================================
-- PART 5: PRACTICAL QUERIES
-- ============================================================================

/*
--------------------------------------------------------------------------------
5.1 - SELECT STATEMENTS
--------------------------------------------------------------------------------

Basic SELECT - Get all columns:
*/

SELECT * FROM Villains;
-- * means "all columns"

-- Get specific columns:
SELECT alias, evil_level FROM Villains;

-- Get specific rows with WHERE:
SELECT * FROM Villains WHERE evil_level >= 8;

-- Multiple conditions:
SELECT * FROM Villains 
WHERE evil_level >= 8 AND preferred_partner_type = 'Maximum Evil';

-- Pattern matching with LIKE:
SELECT * FROM Villains WHERE alias LIKE '%Dark%';
-- % means "any characters"
-- Finds: "Dark Overlord", "Dark Shadow", etc.

-- Sorting results:
SELECT * FROM Villains ORDER BY evil_level DESC;
-- DESC = descending (10, 9, 8...)
-- ASC = ascending (1, 2, 3...)

-- Limiting results:
SELECT * FROM Villains ORDER BY evil_level DESC LIMIT 5;
-- Get top 5 most evil

/*
--------------------------------------------------------------------------------
5.2 - JOIN OPERATIONS
--------------------------------------------------------------------------------

What is a JOIN?
    - Combines rows from two or more tables
    - Based on a related column (usually foreign key)

INNER JOIN - Only matching rows from both tables:
*/

SELECT 
    v.alias,           -- v is alias for Villains
    l.location_name    -- l is alias for Lairs
FROM Villains v
INNER JOIN Lairs l ON v.villain_id = l.villain_id;

-- Result: Only villains who HAVE lairs

/*
LEFT JOIN - All rows from left table, matching from right:
*/

SELECT 
    v.alias,
    l.location_name
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id;

-- Result: ALL villains, even those without lairs
-- Villains without lairs will have NULL for location_name

/*
Multiple JOINs:
*/

SELECT 
    v.alias,
    l.location_name,
    ep.plan_name
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id;

-- Gets villains with their lairs AND plans

/*
Self-JOIN (for Matches table):
*/

SELECT 
    v1.alias AS villain_1,      -- First villain
    v2.alias AS villain_2,      -- Second villain
    m.compatibility_score
FROM Matches m
JOIN Villains v1 ON m.villain_id_1 = v1.villain_id  -- Join first villain
JOIN Villains v2 ON m.villain_id_2 = v2.villain_id; -- Join second villain

-- Shows: "Dark Overlord matched with Dr. Freeze, score 95"

/*
--------------------------------------------------------------------------------
5.3 - AGGREGATE FUNCTIONS
--------------------------------------------------------------------------------

Aggregate functions perform calculations on multiple rows:

COUNT() - Count rows:
*/

SELECT COUNT(*) FROM Villains;
-- How many villains total?

SELECT COUNT(*) FROM Villains WHERE evil_level >= 8;
-- How many villains with evil_level >= 8?

-- COUNT with JOIN:
SELECT 
    v.alias,
    COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias;

-- Shows each villain with their lair count

/*
SUM() - Add up values:
*/

SELECT SUM(budget_in_millions) FROM Evil_Plans;
-- Total budget of all evil plans

SELECT 
    v.alias,
    SUM(ep.budget_in_millions) AS total_budget
FROM Villains v
JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias;

-- Each villain's total plan budget

/*
AVG() - Average value:
*/

SELECT AVG(evil_level) FROM Villains;
-- Average evil level

SELECT AVG(compatibility_score) FROM Matches WHERE match_status = 'Active';
-- Average compatibility of active matches

/*
MIN() and MAX() - Minimum and maximum:
*/

SELECT MIN(evil_level), MAX(evil_level) FROM Villains;
-- Lowest and highest evil level

/*
--------------------------------------------------------------------------------
5.4 - GROUP BY and HAVING
--------------------------------------------------------------------------------

GROUP BY - Group rows with same values:
*/

-- Count villains by evil level:
SELECT 
    evil_level,
    COUNT(*) AS villain_count
FROM Villains
GROUP BY evil_level
ORDER BY evil_level;

-- Result:
-- | evil_level | villain_count |
-- |------------|---------------|
-- | 5          | 1             |
-- | 6          | 2             |
-- | 7          | 2             |
-- ...

/*
HAVING - Filter grouped results (WHERE for groups):
*/

-- Evil levels with more than 1 villain:
SELECT 
    evil_level,
    COUNT(*) AS villain_count
FROM Villains
GROUP BY evil_level
HAVING COUNT(*) > 1;

-- Difference between WHERE and HAVING:
-- WHERE filters individual rows BEFORE grouping
-- HAVING filters groups AFTER grouping

-- Example showing both:
SELECT 
    v.alias,
    COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
WHERE v.evil_level >= 7           -- Filter: only evil villains
GROUP BY v.villain_id, v.alias
HAVING COUNT(l.lair_id) >= 2;     -- Filter: only those with 2+ lairs

/*
--------------------------------------------------------------------------------
5.5 - SUBQUERIES
--------------------------------------------------------------------------------

What is a SUBQUERY?
    - A query inside another query
    - Used to break complex problems into steps

Example: Find villains with above-average evil level:
*/

-- Step 1: Calculate average (subquery)
SELECT AVG(evil_level) FROM Villains;  -- Let's say result is 7.5

-- Step 2: Use that in WHERE clause
SELECT alias, evil_level
FROM Villains
WHERE evil_level > (SELECT AVG(evil_level) FROM Villains);

-- The subquery runs first, then the outer query uses its result

/*
Subquery in FROM clause:
*/

SELECT villain_id, lair_count
FROM (
    SELECT 
        villain_id,
        COUNT(*) AS lair_count
    FROM Lairs
    GROUP BY villain_id
) AS lair_summary
WHERE lair_count > 1;

/*
EXISTS - Check if subquery returns any rows:
*/

-- Find villains WITHOUT any matches:
SELECT alias
FROM Villains v
WHERE NOT EXISTS (
    SELECT 1 FROM Matches m 
    WHERE m.villain_id_1 = v.villain_id OR m.villain_id_2 = v.villain_id
);

/*
IN - Check if value is in subquery results:
*/

-- Find villains who have "In Progress" plans:
SELECT alias
FROM Villains
WHERE villain_id IN (
    SELECT villain_id FROM Evil_Plans WHERE status = 'In Progress'
);

/*
--------------------------------------------------------------------------------
5.6 - VIEWS
--------------------------------------------------------------------------------

What is a VIEW?
    - A saved query that acts like a virtual table
    - Doesn't store data, just the query
    - Makes complex queries reusable

Creating a view:
*/

CREATE VIEW Villain_Summary AS
SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT ep.plan_id) AS plan_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level;

-- Now use it like a table:
SELECT * FROM Villain_Summary WHERE evil_level >= 8;

-- Benefits:
-- 1. Simplifies complex queries
-- 2. Reusable
-- 3. Can grant permissions to view instead of underlying tables
-- 4. Updates automatically when data changes


-- ============================================================================
-- COMPREHENSIVE EXAMPLE - PUTTING IT ALL TOGETHER
-- ============================================================================

/*
Let's build a complex query step by step:

GOAL: Find the top 3 most evil villains who have at least 2 lairs,
      show their match count and total plan budget

Step 1: Get villain info with lair count
*/

SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level;

/*
Step 2: Add match count
*/

SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT CASE 
        WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
    END) AS match_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.evil_level;

/*
Step 3: Add total plan budget
*/

SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT CASE 
        WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
    END) AS match_count,
    COALESCE(SUM(ep.budget_in_millions), 0) AS total_budget
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level;

/*
Step 4: Filter and sort
*/

SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT CASE 
        WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
    END) AS match_count,
    COALESCE(SUM(ep.budget_in_millions), 0) AS total_budget
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level
HAVING COUNT(DISTINCT l.lair_id) >= 2    -- At least 2 lairs
ORDER BY v.evil_level DESC                 -- Most evil first
LIMIT 3;                                   -- Top 3

/*
Explanation of each part:

COUNT(DISTINCT l.lair_id)
    - DISTINCT ensures we don't count same lair multiple times
    - Could happen due to multiple JOINs

COUNT(DISTINCT CASE WHEN...)
    - For matches, we need CASE because matches can appear in either column
    - If villain_id_1 = our villain, count villain_id_2
    - If villain_id_2 = our villain, count villain_id_1

COALESCE(SUM(...), 0)
    - COALESCE returns first non-NULL value
    - If villain has no plans, SUM returns NULL
    - COALESCE converts NULL to 0

LEFT JOIN instead of INNER JOIN
    - We want ALL villains, even those without lairs/plans/matches
    - INNER JOIN would exclude villains without these

HAVING vs WHERE
    - WHERE filters before grouping (can't use aggregate functions)
    - HAVING filters after grouping (can use COUNT, SUM, etc.)

ORDER BY evil_level DESC
    - DESC = descending (10, 9, 8...)
    - We want most evil first

LIMIT 3
    - Only return top 3 results
*/


-- ============================================================================
-- FINAL NOTES
-- ============================================================================

/*
KEY CONCEPTS REVIEW:

1. DATABASE DESIGN
   - Normalize to 3NF (no redundancy)
   - Use appropriate data types
   - Add constraints to ensure data quality

2. RELATIONSHIPS
   - One-to-Many: Foreign key in "many" table
   - Many-to-Many: Junction table with two foreign keys
   - Self-referencing: Foreign key to same table

3. DATA INTEGRITY
   - PRIMARY KEY: Unique identifier
   - FOREIGN KEY: Ensures referential integrity
   - NOT NULL: Required fields
   - UNIQUE: No duplicates
   - CHECK: Validate data
   - DEFAULT: Automatic values

4. PERFORMANCE
   - INDEX: Speed up searches
   - Composite keys: For junction tables
   - Proper joins: Choose LEFT vs INNER appropriately

5. QUERIES
   - SELECT: Retrieve data
   - JOIN: Combine tables
   - WHERE: Filter rows
   - GROUP BY: Aggregate data
   - HAVING: Filter groups
   - ORDER BY: Sort results
   - LIMIT: Restrict row count

PRACTICE TIPS:

1. Start simple, build complexity
2. Test each JOIN separately
3. Use aliases to make queries readable (v for Villains, l for Lairs)
4. Comment your complex queries
5. Check results at each step
6. Use EXPLAIN to understand query performance

COMMON MISTAKES TO AVOID:

1. Forgetting GROUP BY when using aggregate functions
2. Using WHERE instead of HAVING (or vice versa)
3. Not handling NULL values (use COALESCE or IS NULL)
4. Forgetting DISTINCT in counts with multiple JOINs
5. Using SELECT * in production (specify columns)
6. Not indexing foreign keys
7. Over-indexing (slows down writes)

NEXT STEPS:

1. Practice writing queries on this database
2. Try modifying the schema (add tables, columns)
3. Experiment with different JOINs
4. Create your own views
5. Learn about transactions and locks
6. Study query optimization with EXPLAIN
7. Learn about stored procedures and triggers

Happy querying! 💀❤️
*/
