-- ============================================================================
-- EVILMATCH DATABASE - WITH frst_ PREFIX
-- A Dating App for Villains
-- All tables prefixed with: frst_
-- ============================================================================

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS frst_matches;
DROP TABLE IF EXISTS frst_evil_plans;
DROP TABLE IF EXISTS frst_lairs;
DROP TABLE IF EXISTS frst_villains;

-- ============================================================================
-- TABLE 1: frst_villains (Central Entity)
-- ============================================================================

CREATE TABLE frst_villains (
    villain_id INT PRIMARY KEY AUTO_INCREMENT,
    alias VARCHAR(100) NOT NULL,
    real_name VARCHAR(100),
    evil_level INT DEFAULT 1 CHECK (evil_level BETWEEN 1 AND 10),
    preferred_partner_type VARCHAR(50),
    join_date DATE DEFAULT (CURRENT_DATE),
    bio TEXT,
    nemesis VARCHAR(100),
    
    -- Ensure alias is unique (no duplicate villain names)
    UNIQUE(alias),
    
    -- Add index for faster searches on alias
    INDEX idx_alias (alias),
    INDEX idx_evil_level (evil_level)
);

-- ============================================================================
-- TABLE 2: frst_lairs (One-to-Many with frst_villains)
-- ============================================================================

CREATE TABLE frst_lairs (
    lair_id INT PRIMARY KEY AUTO_INCREMENT,
    villain_id INT NOT NULL,
    location_name VARCHAR(150) NOT NULL,
    security_level INT CHECK (security_level BETWEEN 1 AND 5),
    has_lava_moat BOOLEAN DEFAULT FALSE,
    has_shark_tank BOOLEAN DEFAULT FALSE,
    square_footage INT,
    
    -- Foreign key constraint ensures referential integrity
    FOREIGN KEY (villain_id) REFERENCES frst_villains(villain_id)
        ON DELETE CASCADE  -- If villain deleted, their lairs are too
        ON UPDATE CASCADE,
    
    -- Index for faster lookups by villain
    INDEX idx_villain_id (villain_id)
);

-- ============================================================================
-- TABLE 3: frst_evil_plans (One-to-Many with frst_villains)
-- ============================================================================

CREATE TABLE frst_evil_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    villain_id INT NOT NULL,
    plan_name VARCHAR(200) NOT NULL,
    estimated_completion_year INT CHECK (estimated_completion_year >= 2025),
    status VARCHAR(20) DEFAULT 'In Progress' 
        CHECK (status IN ('In Progress', 'Completed', 'Failed', 'On Hold')),
    budget_in_millions DECIMAL(10, 2),
    difficulty_rating INT CHECK (difficulty_rating BETWEEN 1 AND 10),
    
    -- Foreign key ensures plan belongs to valid villain
    FOREIGN KEY (villain_id) REFERENCES frst_villains(villain_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Indexes for common queries
    INDEX idx_villain_id (villain_id),
    INDEX idx_status (status)
);

-- ============================================================================
-- TABLE 4: frst_matches (Many-to-Many Self-Referencing)
-- ============================================================================

CREATE TABLE frst_matches (
    villain_id_1 INT NOT NULL,
    villain_id_2 INT NOT NULL,
    match_date DATE DEFAULT (CURRENT_DATE),
    match_status VARCHAR(20) DEFAULT 'Pending' 
        CHECK (match_status IN ('Pending', 'Active', 'Ghosted', 'Evil Ever After')),
    compatibility_score INT CHECK (compatibility_score BETWEEN 0 AND 100),
    first_date_location VARCHAR(100),
    
    -- Composite primary key prevents duplicate matches
    PRIMARY KEY (villain_id_1, villain_id_2),
    
    -- Foreign keys to ensure both villains exist
    FOREIGN KEY (villain_id_1) REFERENCES frst_villains(villain_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (villain_id_2) REFERENCES frst_villains(villain_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    -- Prevent a villain from matching with themselves
    CHECK (villain_id_1 <> villain_id_2),
    
    -- Ensure consistent ordering (prevent duplicate pairs)
    CHECK (villain_id_1 < villain_id_2),
    
    -- Indexes for query performance
    INDEX idx_status (match_status),
    INDEX idx_match_date (match_date)
);
