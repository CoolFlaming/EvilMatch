-- ============================================================================
-- EVILMATCH DATABASE QUERIES - WITH frst_ PREFIX
-- Useful queries for analyzing villain dating data
-- ============================================================================

-- ============================================================================
-- BASIC QUERIES
-- ============================================================================

-- Query 1: Find all villains with their lair count
SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    COUNT(l.lair_id) AS lair_count
FROM frst_villains v
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level
ORDER BY lair_count DESC;

-- Query 2: Active evil plans by villain
SELECT 
    v.alias,
    ep.plan_name,
    ep.estimated_completion_year,
    ep.budget_in_millions,
    ep.difficulty_rating
FROM frst_villains v
JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id
WHERE ep.status = 'In Progress'
ORDER BY ep.difficulty_rating DESC;

-- Query 3: All matches with villain details
SELECT 
    v1.alias AS villain_1,
    v2.alias AS villain_2,
    m.match_status,
    m.compatibility_score,
    m.match_date,
    m.first_date_location
FROM frst_matches m
JOIN frst_villains v1 ON m.villain_id_1 = v1.villain_id
JOIN frst_villains v2 ON m.villain_id_2 = v2.villain_id
ORDER BY m.compatibility_score DESC;

-- Query 4: Most evil villains with active matches
SELECT 
    v.alias,
    v.evil_level,
    COUNT(DISTINCT m.villain_id_2) AS active_matches,
    COUNT(DISTINCT ep.plan_id) AS active_plans
FROM frst_villains v
LEFT JOIN frst_matches m ON v.villain_id = m.villain_id_1 AND m.match_status = 'Active'
LEFT JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id AND ep.status = 'In Progress'
WHERE v.evil_level >= 8
GROUP BY v.villain_id, v.alias, v.evil_level
ORDER BY v.evil_level DESC;

-- Query 5: Lairs with maximum security
SELECT 
    v.alias,
    l.location_name,
    l.security_level,
    l.has_lava_moat,
    l.has_shark_tank,
    l.square_footage
FROM frst_lairs l
JOIN frst_villains v ON l.villain_id = v.villain_id
WHERE l.security_level = 5
ORDER BY l.square_footage DESC;

-- Query 6: Villain compatibility insights
SELECT 
    v.alias,
    v.preferred_partner_type,
    AVG(m.compatibility_score) AS avg_compatibility,
    COUNT(*) AS total_matches
FROM frst_villains v
JOIN frst_matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.preferred_partner_type
HAVING COUNT(*) > 0
ORDER BY avg_compatibility DESC;

-- ============================================================================
-- ADVANCED QUERIES
-- ============================================================================

-- Query 7: Total evil plan budget by villain
SELECT 
    v.alias,
    v.evil_level,
    SUM(ep.budget_in_millions) AS total_budget,
    COUNT(ep.plan_id) AS plan_count,
    AVG(ep.difficulty_rating) AS avg_difficulty
FROM frst_villains v
JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id
GROUP BY v.villain_id, v.alias, v.evil_level
ORDER BY total_budget DESC;

-- Query 8: Matches by status breakdown
SELECT 
    match_status,
    COUNT(*) AS total_matches,
    AVG(compatibility_score) AS avg_compatibility
FROM frst_matches
GROUP BY match_status
ORDER BY total_matches DESC;

-- Query 9: Most popular villains (most matches)
SELECT 
    v.alias,
    v.evil_level,
    v.preferred_partner_type,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN m.match_status = 'Active' THEN 1 ELSE 0 END) AS active_matches,
    SUM(CASE WHEN m.match_status = 'Evil Ever After' THEN 1 ELSE 0 END) AS committed_matches
FROM frst_villains v
JOIN frst_matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.evil_level, v.preferred_partner_type
ORDER BY total_matches DESC;

-- Query 10: Villains without any matches (singles ready to mingle)
SELECT 
    v.alias,
    v.evil_level,
    v.preferred_partner_type,
    v.bio
FROM frst_villains v
WHERE NOT EXISTS (
    SELECT 1 FROM frst_matches m 
    WHERE m.villain_id_1 = v.villain_id OR m.villain_id_2 = v.villain_id
)
ORDER BY v.evil_level DESC;

-- Query 11: Most ambitious villains (highest difficulty plans)
SELECT 
    v.alias,
    ep.plan_name,
    ep.difficulty_rating,
    ep.budget_in_millions,
    ep.status
FROM frst_villains v
JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id
WHERE ep.difficulty_rating >= 9
ORDER BY ep.difficulty_rating DESC, ep.budget_in_millions DESC;

-- Query 12: Lair security analysis
SELECT 
    security_level,
    COUNT(*) AS lair_count,
    SUM(CASE WHEN has_lava_moat = TRUE THEN 1 ELSE 0 END) AS lava_moat_count,
    SUM(CASE WHEN has_shark_tank = TRUE THEN 1 ELSE 0 END) AS shark_tank_count,
    AVG(square_footage) AS avg_square_footage
FROM frst_lairs
GROUP BY security_level
ORDER BY security_level DESC;

-- ============================================================================
-- DATING APP SPECIFIC QUERIES
-- ============================================================================

-- Query 13: Recommended matches (villains with similar evil levels, no existing match)
SELECT 
    v1.alias AS villain,
    v2.alias AS potential_match,
    v1.evil_level,
    v2.evil_level,
    ABS(v1.evil_level - v2.evil_level) AS level_difference
FROM frst_villains v1
CROSS JOIN frst_villains v2
WHERE v1.villain_id < v2.villain_id
AND NOT EXISTS (
    SELECT 1 FROM frst_matches m 
    WHERE (m.villain_id_1 = v1.villain_id AND m.villain_id_2 = v2.villain_id)
)
AND ABS(v1.evil_level - v2.evil_level) <= 2
ORDER BY level_difference, v1.evil_level DESC
LIMIT 10;

-- Query 14: Success rate by preferred partner type
SELECT 
    v.preferred_partner_type,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN m.match_status IN ('Active', 'Evil Ever After') THEN 1 ELSE 0 END) AS successful_matches,
    ROUND(SUM(CASE WHEN m.match_status IN ('Active', 'Evil Ever After') THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM frst_villains v
JOIN frst_matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.preferred_partner_type
ORDER BY success_rate DESC;

-- Query 15: Recently joined villains (last 30 days - adjust date as needed)
SELECT 
    v.alias,
    v.evil_level,
    v.preferred_partner_type,
    v.join_date,
    COUNT(l.lair_id) AS lair_count,
    COUNT(ep.plan_id) AS plan_count
FROM frst_villains v
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
LEFT JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id
WHERE v.join_date >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
GROUP BY v.villain_id, v.alias, v.evil_level, v.preferred_partner_type, v.join_date
ORDER BY v.join_date DESC;

-- ============================================================================
-- CREATE USEFUL VIEWS
-- ============================================================================

-- View 1: Villain Profile Summary
CREATE OR REPLACE VIEW frst_villain_profile_summary AS
SELECT 
    v.villain_id,
    v.alias,
    v.real_name,
    v.evil_level,
    v.preferred_partner_type,
    COUNT(DISTINCT l.lair_id) AS total_lairs,
    COUNT(DISTINCT ep.plan_id) AS total_plans,
    COUNT(DISTINCT CASE WHEN m.villain_id_1 = v.villain_id THEN m.villain_id_2
                        WHEN m.villain_id_2 = v.villain_id THEN m.villain_id_1 END) AS total_matches,
    SUM(ep.budget_in_millions) AS total_plan_budget
FROM frst_villains v
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
LEFT JOIN frst_evil_plans ep ON v.villain_id = ep.villain_id
LEFT JOIN frst_matches m ON v.villain_id = m.villain_id_1 OR v.villain_id = m.villain_id_2
GROUP BY v.villain_id, v.alias, v.real_name, v.evil_level, v.preferred_partner_type;

-- View 2: Active Dating Pool
CREATE OR REPLACE VIEW frst_active_dating_pool AS
SELECT 
    v.villain_id,
    v.alias,
    v.evil_level,
    v.preferred_partner_type,
    v.bio,
    COUNT(DISTINCT l.lair_id) AS lair_count,
    COUNT(DISTINCT CASE WHEN m.match_status = 'Active' THEN m.villain_id_2 END) AS current_active_matches
FROM frst_villains v
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
LEFT JOIN frst_matches m ON v.villain_id = m.villain_id_1
GROUP BY v.villain_id, v.alias, v.evil_level, v.preferred_partner_type, v.bio
HAVING current_active_matches < 3;  -- Available for more matches

-- View 3: Evil Plan Dashboard
CREATE OR REPLACE VIEW frst_evil_plan_dashboard AS
SELECT 
    v.alias,
    ep.plan_name,
    ep.status,
    ep.estimated_completion_year,
    ep.budget_in_millions,
    ep.difficulty_rating,
    COUNT(l.lair_id) AS available_lairs
FROM frst_evil_plans ep
JOIN frst_villains v ON ep.villain_id = v.villain_id
LEFT JOIN frst_lairs l ON v.villain_id = l.villain_id
GROUP BY v.alias, ep.plan_id, ep.plan_name, ep.status, ep.estimated_completion_year, ep.budget_in_millions, ep.difficulty_rating;

-- ============================================================================
-- QUERY THE VIEWS
-- ============================================================================

-- Show all villain profiles
SELECT * FROM frst_villain_profile_summary ORDER BY evil_level DESC;

-- Show available villains for matching
SELECT * FROM frst_active_dating_pool ORDER BY lair_count DESC;

-- Show all evil plans overview
SELECT * FROM frst_evil_plan_dashboard WHERE status = 'In Progress' ORDER BY difficulty_rating DESC;
