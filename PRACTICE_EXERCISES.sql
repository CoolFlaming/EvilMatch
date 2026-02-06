-- ============================================================================
-- EVILMATCH DATABASE - PRACTICE EXERCISES
-- Hands-On SQL Practice with Solutions
-- ============================================================================

/*
HOW TO USE THIS FILE:
1. Read each exercise
2. Try to write the SQL yourself BEFORE looking at the solution
3. Test your query on the database
4. Compare with the provided solution
5. Understand WHY the solution works

DIFFICULTY LEVELS:
★☆☆☆☆ = Beginner (Basic SELECT, WHERE)
★★☆☆☆ = Easy (Simple JOINs, basic aggregates)
★★★☆☆ = Intermediate (Multiple JOINs, GROUP BY, HAVING)
★★★★☆ = Advanced (Subqueries, complex aggregates)
★★★★★ = Expert (Self-joins, complex business logic)
*/

-- ============================================================================
-- SECTION 1: BASIC QUERIES (★☆☆☆☆)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 1.1: Get all villains
-- Task: Write a query to show all villains' aliases and evil levels
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level 
FROM Villains;

-- EXPLANATION:
-- SELECT specifies which columns we want
-- FROM specifies which table to get data from


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 1.2: Filter by evil level
-- Task: Find all villains with evil_level greater than or equal to 8
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level 
FROM Villains 
WHERE evil_level >= 8;

-- EXPLANATION:
-- WHERE clause filters rows
-- >= means "greater than or equal to"
-- Only rows where evil_level is 8, 9, or 10 will be returned


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 1.3: Pattern matching
-- Task: Find all villains whose alias contains the word "Dark"
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level 
FROM Villains 
WHERE alias LIKE '%Dark%';

-- EXPLANATION:
-- LIKE is used for pattern matching
-- % means "any characters" (wildcard)
-- '%Dark%' matches: "Dark Overlord", "The Dark One", "Darkness Falls", etc.
-- 'Dark%' would only match names STARTING with "Dark"
-- '%Dark' would only match names ENDING with "Dark"


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 1.4: Sorting results
-- Task: Get all villains sorted by evil_level from highest to lowest
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level 
FROM Villains 
ORDER BY evil_level DESC;

-- EXPLANATION:
-- ORDER BY sorts results
-- DESC = descending (10, 9, 8, 7...)
-- ASC = ascending (1, 2, 3, 4...) [default if not specified]


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 1.5: Limit results
-- Task: Get the top 3 most evil villains
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level 
FROM Villains 
ORDER BY evil_level DESC 
LIMIT 3;

-- EXPLANATION:
-- LIMIT restricts the number of rows returned
-- Combined with ORDER BY DESC, we get the TOP 3
-- First sorts by evil_level (highest first), then takes first 3 rows


-- ============================================================================
-- SECTION 2: SIMPLE JOINS (★★☆☆☆)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 2.1: Basic JOIN
-- Task: Show each lair with its owner's name
-- Columns: alias, location_name
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT v.alias, l.location_name
FROM Villains v
JOIN Lairs l ON v.villain_id = l.villain_id;

-- EXPLANATION:
-- JOIN combines two tables
-- v and l are aliases (nicknames) for the tables
-- ON specifies how to match rows: when villain_id is the same
-- Only rows with matching villain_id values are included


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 2.2: JOIN with WHERE
-- Task: Show lairs that have maximum security (level 5) with owner names
-- Columns: alias, location_name, security_level
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT v.alias, l.location_name, l.security_level
FROM Villains v
JOIN Lairs l ON v.villain_id = l.villain_id
WHERE l.security_level = 5;

-- EXPLANATION:
-- First, JOIN combines tables
-- Then, WHERE filters the joined results
-- Only lairs with security_level = 5 are shown


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 2.3: LEFT JOIN
-- Task: Show ALL villains and their lairs (including villains without lairs)
-- Columns: alias, location_name
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT v.alias, l.location_name
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id;

-- EXPLANATION:
-- LEFT JOIN includes ALL rows from left table (Villains)
-- Even if no matching row in right table (Lairs)
-- Villains without lairs will show NULL for location_name
-- INNER JOIN would exclude villains without lairs


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 2.4: Multiple table JOIN
-- Task: Show villains with their lairs AND evil plans
-- Columns: alias, location_name, plan_name
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT v.alias, l.location_name, ep.plan_name
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id;

-- EXPLANATION:
-- Can join multiple tables in one query
-- First joins Villains with Lairs
-- Then joins that result with Evil_Plans
-- Using LEFT JOIN ensures we see all villains even if they lack lairs or plans


-- ============================================================================
-- SECTION 3: AGGREGATE FUNCTIONS (★★★☆☆)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.1: COUNT
-- Task: How many villains are in the database?
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT COUNT(*) AS total_villains
FROM Villains;

-- EXPLANATION:
-- COUNT(*) counts all rows
-- AS gives the result column a name (total_villains)
-- Result is a single number


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.2: COUNT with WHERE
-- Task: How many villains have evil_level of 8 or higher?
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT COUNT(*) AS highly_evil_count
FROM Villains
WHERE evil_level >= 8;

-- EXPLANATION:
-- WHERE filters BEFORE counting
-- Only counts rows where evil_level >= 8


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.3: SUM
-- Task: What is the total budget of all evil plans?
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT SUM(budget_in_millions) AS total_budget
FROM Evil_Plans;

-- EXPLANATION:
-- SUM adds up all values in a column
-- Result is the sum of all budgets


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.4: AVG, MIN, MAX
-- Task: Find the average, minimum, and maximum evil levels
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    AVG(evil_level) AS avg_evil,
    MIN(evil_level) AS min_evil,
    MAX(evil_level) AS max_evil
FROM Villains;

-- EXPLANATION:
-- AVG calculates average
-- MIN finds smallest value
-- MAX finds largest value
-- All in one query!


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.5: GROUP BY
-- Task: Count how many villains exist at each evil level
-- Columns: evil_level, villain_count
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    evil_level,
    COUNT(*) AS villain_count
FROM Villains
GROUP BY evil_level
ORDER BY evil_level;

-- EXPLANATION:
-- GROUP BY groups rows with same evil_level together
-- COUNT(*) counts rows in each group
-- Result shows: evil_level 5 has 1 villain, level 6 has 2 villains, etc.


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.6: GROUP BY with JOIN
-- Task: Show each villain with their lair count
-- Columns: alias, lair_count
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias
ORDER BY lair_count DESC;

-- EXPLANATION:
-- LEFT JOIN includes all villains
-- GROUP BY v.villain_id groups by each villain
-- COUNT(l.lair_id) counts lairs for each villain
-- COUNT(NULL) = 0, so villains without lairs show 0


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 3.7: HAVING clause
-- Task: Show villains who have MORE than 1 lair
-- Columns: alias, lair_count
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    COUNT(l.lair_id) AS lair_count
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias
HAVING COUNT(l.lair_id) > 1
ORDER BY lair_count DESC;

-- EXPLANATION:
-- HAVING filters AFTER grouping
-- WHERE filters BEFORE grouping
-- Use HAVING when filtering on aggregate functions (COUNT, SUM, etc.)
-- This shows only villains with lair_count > 1


-- ============================================================================
-- SECTION 4: ADVANCED QUERIES (★★★★☆)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 4.1: Subquery
-- Task: Find villains with above-average evil level
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level
FROM Villains
WHERE evil_level > (SELECT AVG(evil_level) FROM Villains)
ORDER BY evil_level DESC;

-- EXPLANATION:
-- Inner query (SELECT AVG...) runs FIRST
-- Returns a single number (average evil level)
-- Outer query uses that number in WHERE clause
-- Shows only villains above that average


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 4.2: EXISTS subquery
-- Task: Find villains who have at least one active match
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level
FROM Villains v
WHERE EXISTS (
    SELECT 1 FROM Matches m 
    WHERE (m.villain_id_1 = v.villain_id OR m.villain_id_2 = v.villain_id)
    AND m.match_status = 'Active'
);

-- EXPLANATION:
-- EXISTS checks if subquery returns any rows
-- For each villain, checks if they have an active match
-- Returns TRUE if at least one row found, FALSE otherwise
-- Only villains where EXISTS returns TRUE are included


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 4.3: NOT EXISTS
-- Task: Find villains who have NO matches at all
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level
FROM Villains v
WHERE NOT EXISTS (
    SELECT 1 FROM Matches m 
    WHERE m.villain_id_1 = v.villain_id OR m.villain_id_2 = v.villain_id
);

-- EXPLANATION:
-- NOT EXISTS is the opposite of EXISTS
-- Returns TRUE if subquery finds NO rows
-- Shows villains who don't appear in Matches table at all


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 4.4: IN with subquery
-- Task: Find villains who have "In Progress" evil plans
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT alias, evil_level
FROM Villains
WHERE villain_id IN (
    SELECT villain_id 
    FROM Evil_Plans 
    WHERE status = 'In Progress'
);

-- EXPLANATION:
-- IN checks if value is in a list
-- Subquery returns list of villain_ids with active plans
-- Outer query shows villains whose ID is in that list


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 4.5: Complex aggregation
-- Task: Show each villain's total plan budget and most difficult plan rating
-- Columns: alias, total_budget, max_difficulty
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    COALESCE(SUM(ep.budget_in_millions), 0) AS total_budget,
    MAX(ep.difficulty_rating) AS max_difficulty
FROM Villains v
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias
ORDER BY total_budget DESC;

-- EXPLANATION:
-- COALESCE returns first non-NULL value
-- If no plans, SUM is NULL → COALESCE converts to 0
-- MAX finds highest difficulty rating for each villain
-- LEFT JOIN ensures all villains shown, even without plans


-- ============================================================================
-- SECTION 5: SELF-REFERENCING QUERIES (★★★★★)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 5.1: Self-join basics
-- Task: Show all matches with both villain names
-- Columns: villain_1_name, villain_2_name, compatibility_score
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v1.alias AS villain_1_name,
    v2.alias AS villain_2_name,
    m.compatibility_score
FROM Matches m
JOIN Villains v1 ON m.villain_id_1 = v1.villain_id
JOIN Villains v2 ON m.villain_id_2 = v2.villain_id
ORDER BY m.compatibility_score DESC;

-- EXPLANATION:
-- Self-join: Villains table joined TWICE
-- v1 = first villain in match
-- v2 = second villain in match
-- Both v1 and v2 refer to same table but different rows


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 5.2: Find villain with most matches
-- Task: Show villain(s) with highest number of total matches
-- Columns: alias, match_count
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    COUNT(*) AS match_count
FROM Villains v
JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias
ORDER BY match_count DESC
LIMIT 1;

-- EXPLANATION:
-- OR condition: villain can be in either column of Matches
-- Counts all matches where villain appears
-- GROUP BY villain to get count per villain
-- LIMIT 1 shows only the top result


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 5.3: Mutual matches
-- Task: Find pairs of villains who both matched each other as "Active"
-- This tests understanding of self-referencing and complex conditions
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v1.alias AS villain_1,
    v2.alias AS villain_2,
    m.compatibility_score
FROM Matches m
JOIN Villains v1 ON m.villain_id_1 = v1.villain_id
JOIN Villains v2 ON m.villain_id_2 = v2.villain_id
WHERE m.match_status = 'Active';

-- EXPLANATION:
-- In our design, a match (1,2) represents BOTH directions
-- We don't store both (1,2) and (2,1) - that would be redundant
-- One row represents the mutual match
-- Filter by status = 'Active' to show only active relationships


-- ============================================================================
-- SECTION 6: REAL-WORLD SCENARIOS (★★★★★)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 6.1: Dating app recommendations
-- Task: Find potential matches for villain_id = 1
-- Requirements:
-- - Same evil_level (±1 level difference)
-- - NOT already matched
-- - NOT the same villain
-- Columns: recommended_villain, evil_level, level_difference
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v2.alias AS recommended_villain,
    v2.evil_level,
    ABS(v1.evil_level - v2.evil_level) AS level_difference
FROM Villains v1
CROSS JOIN Villains v2
WHERE v1.villain_id = 1                    -- For specific villain
AND v2.villain_id != v1.villain_id         -- Not themselves
AND ABS(v1.evil_level - v2.evil_level) <= 1   -- Similar evil level
AND NOT EXISTS (                            -- Not already matched
    SELECT 1 FROM Matches m 
    WHERE (m.villain_id_1 = v1.villain_id AND m.villain_id_2 = v2.villain_id)
       OR (m.villain_id_1 = v2.villain_id AND m.villain_id_2 = v1.villain_id)
)
ORDER BY level_difference, v2.evil_level DESC;

-- EXPLANATION:
-- CROSS JOIN creates all possible pairs
-- Multiple WHERE conditions filter:
--   1. For our specific villain
--   2. Exclude self
--   3. Similar evil levels (ABS gets absolute difference)
--   4. No existing match (checked both directions)


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 6.2: Villain profile dashboard
-- Task: Create comprehensive profile for each villain
-- Columns: alias, evil_level, lair_count, plan_count, active_match_count, 
--          total_budget
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT ep.plan_id) AS plan_count,
    COUNT(DISTINCT CASE 
        WHEN m.match_status = 'Active' THEN 
            CASE 
                WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
                WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
            END 
    END) AS active_match_count,
    COALESCE(SUM(ep.budget_in_millions), 0) AS total_budget
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
LEFT JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.evil_level
ORDER BY v.evil_level DESC;

-- EXPLANATION:
-- Multiple LEFT JOINs get all related data
-- COUNT(DISTINCT ...) prevents double-counting from joins
-- Nested CASE for matches: counts other villain in active matches
-- COALESCE converts NULL totals to 0
-- All calculations per villain due to GROUP BY


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 6.3: Success rate by match status
-- Task: Calculate percentage distribution of match statuses
-- Columns: match_status, count, percentage
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    match_status,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Matches), 2) AS percentage
FROM Matches
GROUP BY match_status
ORDER BY count DESC;

-- EXPLANATION:
-- Subquery (SELECT COUNT(*) FROM Matches) gets total matches
-- Main query counts matches per status
-- Multiply by 100.0 to get percentage (use .0 for decimal division)
-- ROUND to 2 decimal places
-- Shows distribution: 40% Active, 30% Pending, etc.


-- ────────────────────────────────────────────────────────────────────────────
-- EXERCISE 6.4: Top evil masterminds
-- Task: Find top 5 villains by combined metrics:
-- - Most evil (evil_level)
-- - Most lairs
-- - Highest total plan budget
-- - Most matches
-- Create a "score" that combines these factors
-- ────────────────────────────────────────────────────────────────────────────

-- YOUR ATTEMPT:
-- (Write your query here)




-- SOLUTION:
SELECT 
    v.alias,
    v.evil_level,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT ep.plan_id) AS plan_count,
    COALESCE(SUM(ep.budget_in_millions), 0) AS total_budget,
    COUNT(DISTINCT CASE 
        WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
    END) AS match_count,
    (v.evil_level * 10) +                           -- Evil level weighted 10x
    (COUNT(DISTINCT l.lair_id) * 5) +               -- Lairs weighted 5x
    (COALESCE(SUM(ep.budget_in_millions), 0) / 100) + -- Budget weighted /100
    (COUNT(DISTINCT CASE 
        WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1
    END) * 2)                                        -- Matches weighted 2x
    AS mastermind_score
FROM Villains v
LEFT JOIN Lairs l ON v.villain_id = l.villain_id
LEFT JOIN Evil_Plans ep ON v.villain_id = ep.villain_id
LEFT JOIN Matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.evil_level
ORDER BY mastermind_score DESC
LIMIT 5;

-- EXPLANATION:
-- Combines multiple metrics into one score
-- Different weights for different factors (evil_level worth more than matches)
-- Budget divided by 100 to keep it proportional
-- ORDER BY score to rank villains
-- LIMIT 5 shows top masterminds


-- ============================================================================
-- BONUS CHALLENGES (★★★★★)
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- CHALLENGE 1: Find "power couples"
-- Task: Find matches with BOTH villains having evil_level >= 8
-- AND compatibility_score >= 90
-- Show as "Power Couples"
-- ────────────────────────────────────────────────────────────────────────────

-- SOLUTION:
SELECT 
    v1.alias AS villain_1,
    v1.evil_level AS evil_1,
    v2.alias AS villain_2,
    v2.evil_level AS evil_2,
    m.compatibility_score,
    'Power Couple' AS category
FROM Matches m
JOIN Villains v1 ON m.villain_id_1 = v1.villain_id
JOIN Villains v2 ON m.villain_id_2 = v2.villain_id
WHERE v1.evil_level >= 8 
AND v2.evil_level >= 8
AND m.compatibility_score >= 90
ORDER BY m.compatibility_score DESC;


-- ────────────────────────────────────────────────────────────────────────────
-- CHALLENGE 2: Underutilized lairs
-- Task: Find lairs owned by villains with NO active evil plans
-- These lairs could be repurposed or sold!
-- ────────────────────────────────────────────────────────────────────────────

-- SOLUTION:
SELECT 
    v.alias,
    l.location_name,
    l.security_level,
    l.square_footage
FROM Lairs l
JOIN Villains v ON l.villain_id = v.villain_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM Evil_Plans ep 
    WHERE ep.villain_id = v.villain_id 
    AND ep.status = 'In Progress'
)
ORDER BY l.square_footage DESC;


-- ────────────────────────────────────────────────────────────────────────────
-- CHALLENGE 3: Dating app analytics
-- Task: Create a comprehensive report showing:
-- - Total villains
-- - Total matches by status
-- - Average compatibility score
-- - Most common preferred partner type
-- All in ONE query!
-- ────────────────────────────────────────────────────────────────────────────

-- SOLUTION:
SELECT 
    (SELECT COUNT(*) FROM Villains) AS total_villains,
    (SELECT COUNT(*) FROM Matches WHERE match_status = 'Active') AS active_matches,
    (SELECT COUNT(*) FROM Matches WHERE match_status = 'Pending') AS pending_matches,
    (SELECT COUNT(*) FROM Matches WHERE match_status = 'Ghosted') AS ghosted_matches,
    (SELECT ROUND(AVG(compatibility_score), 2) FROM Matches) AS avg_compatibility,
    (SELECT preferred_partner_type 
     FROM Villains 
     GROUP BY preferred_partner_type 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_common_preference;

-- EXPLANATION:
-- Multiple subqueries in SELECT clause
-- Each subquery is independent
-- Result is a single row with all statistics
-- Last subquery finds most common preference using GROUP BY + ORDER BY + LIMIT


-- ============================================================================
-- PRACTICE TIPS
-- ============================================================================

/*
1. START SIMPLE
   - Begin with SELECT * to see all data
   - Add WHERE clauses one at a time
   - Test each condition separately

2. BUILD COMPLEXITY GRADUALLY
   - First get the JOIN working
   - Then add WHERE filters
   - Then add GROUP BY
   - Finally add ORDER BY and LIMIT

3. USE COMMENTS
   - Comment what each part does
   - Helps you understand your own code later

4. TEST WITH SMALL DATA
   - Use LIMIT to see just a few rows
   - Easier to verify results are correct

5. CHECK YOUR JOINS
   - Make sure you're using the right columns
   - Verify LEFT vs INNER JOIN choice
   - Count rows before and after JOIN

6. UNDERSTAND AGGREGATES
   - COUNT(*) counts all rows
   - COUNT(column) counts non-NULL values
   - Use DISTINCT to avoid double-counting

7. WATCH FOR NULL
   - NULL != NULL (use IS NULL instead)
   - Functions like COUNT skip NULLs
   - Use COALESCE to handle NULLs

8. THINK IN SETS
   - SQL operates on SETS of rows
   - Not row-by-row like programming loops
   - GROUP BY creates sets

COMMON MISTAKES:

✗ SELECT alias FROM Villains GROUP BY evil_level
  → Error: alias not in GROUP BY

✓ SELECT evil_level FROM Villains GROUP BY evil_level
  → Correct: only grouped column in SELECT

✗ WHERE COUNT(*) > 5
  → Error: Can't use aggregate in WHERE

✓ HAVING COUNT(*) > 5
  → Correct: Use HAVING for aggregates

✗ SELECT * FROM Villains v JOIN Lairs
  → Error: Missing ON clause

✓ SELECT * FROM Villains v JOIN Lairs l ON v.villain_id = l.villain_id
  → Correct: JOIN needs ON condition

HAPPY PRACTICING! 💀❤️
*/
