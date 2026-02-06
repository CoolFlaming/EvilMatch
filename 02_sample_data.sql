-- ============================================================================
-- EvilMatch Sample Data
-- Populate the database with example villains, lairs, plans, and matches
-- ============================================================================

-- ============================================================================
-- INSERT VILLAINS
-- ============================================================================

INSERT INTO Villains (alias, real_name, evil_level, preferred_partner_type, bio, nemesis) VALUES
('The Dark Overlord', 'Derek Johnson', 9, 'Equally Evil', 'Seeking partner for world domination and cozy apocalypses', 'Captain Sunshine'),
('Dr. Freeze-Frame', 'Francine Frost', 7, 'Tech-Savvy', 'Ice queen looking for someone to chill with', 'The Flame'),
('Shadow Serpent', 'Sarah Chen', 8, 'Mysterious', 'Loves long slithers on the beach and poisoning heroes', 'Snake Charmer'),
('Count Chaos', 'Vladimir Petrov', 10, 'Maximum Evil', 'Immortal vampire seeking eternal romance', 'Van Helsing Jr.'),
('The Riddler 2.0', 'Rita Martinez', 6, 'Intellectual', 'Puzzle enthusiast, loves mind games and escape rooms', 'Detective Logic'),
('Toxic Avenger', 'Thomas Green', 5, 'Eco-Conscious Evil', 'Environmental villain with a heart... somewhere', 'Captain Planet'),
('Madame Mayhem', 'Marie Dubois', 8, 'Chaotic Neutral', 'French villainess specializing in art heists and chaos', 'Inspector Clouseau'),
('The Phantom Hacker', 'Alex Kumar', 7, 'Digital Native', 'Master of cyber warfare and digital destruction', 'CyberCop'),
('Queen Venom', 'Victoria Stone', 9, 'Power Couple', 'Biochemist creating the perfect poison for a perfect world', 'AntidoteMan'),
('Lord Nightmare', 'Nathan Cross', 6, 'Dream Partner', 'Controls dreams and fears, seeks someone to share nightmares with', 'Dream Defender');

-- ============================================================================
-- INSERT LAIRS
-- ============================================================================

INSERT INTO Lairs (villain_id, location_name, security_level, has_lava_moat, has_shark_tank, square_footage) VALUES
-- Dark Overlord's lairs
(1, 'Volcano Fortress, Mt. Doom', 5, TRUE, TRUE, 50000),
(1, 'Underground Bunker, Nevada', 4, FALSE, FALSE, 25000),

-- Dr. Freeze-Frame's lair
(2, 'Arctic Ice Palace', 5, FALSE, TRUE, 40000),

-- Shadow Serpent's lair
(3, 'Abandoned Subway Network, NYC', 3, FALSE, TRUE, 15000),

-- Count Chaos's lairs
(4, 'Gothic Castle, Transylvania', 5, TRUE, FALSE, 80000),
(4, 'Penthouse Suite, Dark Tower', 4, FALSE, TRUE, 12000),

-- The Riddler 2.0's lair
(5, 'Puzzle Maze Complex, Singapore', 4, FALSE, FALSE, 30000),

-- Toxic Avenger's lair
(6, 'Toxic Waste Facility, New Jersey', 2, FALSE, FALSE, 20000),

-- Madame Mayhem's lair
(7, 'Secret Gallery, Paris Catacombs', 5, FALSE, TRUE, 18000),

-- The Phantom Hacker's lair
(8, 'Data Center, Silicon Valley', 3, FALSE, FALSE, 8000),

-- Queen Venom's lair
(9, 'Laboratory Complex, Amazon Rainforest', 4, TRUE, TRUE, 35000),

-- Lord Nightmare's lair
(10, 'Abandoned Asylum, Sleepy Hollow', 3, FALSE, FALSE, 22000);

-- ============================================================================
-- INSERT EVIL PLANS
-- ============================================================================

INSERT INTO Evil_Plans (villain_id, plan_name, estimated_completion_year, status, budget_in_millions, difficulty_rating) VALUES
-- Dark Overlord's plans
(1, 'Global Network Shutdown', 2027, 'In Progress', 500.00, 9),
(1, 'Moon Base Construction', 2030, 'In Progress', 2000.00, 10),

-- Dr. Freeze-Frame's plans
(2, 'Freeze All Ocean Water', 2026, 'In Progress', 750.00, 8),
(2, 'Create Eternal Winter', 2028, 'On Hold', 1200.00, 9),

-- Shadow Serpent's plans
(3, 'Infiltrate World Governments', 2028, 'In Progress', 100.00, 7),
(3, 'Create Army of Serpent Minions', 2026, 'In Progress', 50.00, 6),

-- Count Chaos's plans
(4, 'Vampire Army Recruitment', 2025, 'In Progress', 50.00, 6),
(4, 'Block Out The Sun', 2035, 'On Hold', 5000.00, 10),

-- The Riddler 2.0's plans
(5, 'Encrypt All Digital Currency', 2026, 'In Progress', 200.00, 8),
(5, 'Turn City Into Giant Puzzle', 2027, 'In Progress', 150.00, 7),

-- Toxic Avenger's plans
(6, 'Pollute All Freshwater Sources', 2029, 'Failed', 300.00, 7),

-- Madame Mayhem's plans
(7, 'Steal Crown Jewels From Every Country', 2026, 'In Progress', 75.00, 8),
(7, 'Replace World Art With Forgeries', 2030, 'In Progress', 500.00, 9),

-- The Phantom Hacker's plans
(8, 'Control All Social Media Platforms', 2025, 'In Progress', 100.00, 7),
(8, 'Launch Satellite Surveillance Network', 2027, 'In Progress', 800.00, 8),

-- Queen Venom's plans
(9, 'Create Undetectable Poison', 2025, 'Completed', 25.00, 9),
(9, 'Genetically Engineer Venomous Plants', 2026, 'In Progress', 200.00, 8),

-- Lord Nightmare's plans
(10, 'Broadcast Fear Into Every Dream', 2028, 'In Progress', 300.00, 7),
(10, 'Create Dream Reality Convergence', 2032, 'On Hold', 1000.00, 10);

-- ============================================================================
-- INSERT MATCHES
-- ============================================================================

INSERT INTO Matches (villain_id_1, villain_id_2, match_status, compatibility_score, first_date_location) VALUES
-- Active relationships
(1, 4, 'Active', 95, 'Rooftop overlooking city destruction'),
(3, 5, 'Active', 88, 'Escape room (they made the staff escape)'),
(5, 6, 'Evil Ever After', 91, 'Toxic puzzle garden'),
(7, 8, 'Active', 85, 'Museum after hours heist'),
(9, 10, 'Active', 87, 'Laboratory filled with nightmares'),

-- Pending matches
(1, 3, 'Pending', 78, NULL),
(4, 2, 'Pending', 82, NULL),
(2, 9, 'Pending', 75, NULL),
(6, 10, 'Pending', 70, NULL),

-- Ghosted situations
(2, 6, 'Ghosted', 45, 'Ice skating rink (melted)'),
(4, 7, 'Ghosted', 60, 'Blood bank donation drive'),
(8, 10, 'Ghosted', 55, 'Virtual reality nightmare'),

-- More active matches
(1, 9, 'Active', 92, 'Abandoned chemical plant'),
(3, 7, 'Active', 83, 'Underground snake pit art gallery'),
(4, 9, 'Evil Ever After', 98, 'Vampire blood tasting with poison samples');
