-- =====================================================
-- Delete Duplicate Emails Query
-- =====================================================
-- Purpose: Remove duplicate email records, keeping the one with smallest id
-- Action: DELETE duplicate rows from Person table
-- Method: Self-join to identify and delete duplicates
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Person;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Person table
CREATE TABLE Person (
    id INT PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Person (id, email) VALUES
(1, 'john@example.com'),    -- KEEP (smallest id)
(2, 'bob@example.com'),     -- KEEP (unique)
(3, 'john@example.com');    -- DELETE (duplicate, larger id)

-- =====================================================
-- BEFORE DELETION:
-- =====================================================
-- id | email
-- ---|------------------
-- 1  | john@example.com
-- 2  | bob@example.com
-- 3  | john@example.com

-- =====================================================
-- MAIN QUERY: DELETE with SELF-JOIN
-- =====================================================

DELETE
    p1                          -- Delete from first instance
FROM 
    Person AS p1                -- p1 = rows to delete
JOIN
    Person AS p2                -- p2 = rows to compare
ON
    p1.email = p2.email         -- Match rows with same email
    AND p1.id > p2.id;          -- Delete larger id, keep smaller id

-- =====================================================      
-- HOW IT WORKS:                                        
-- =====================================================               
-- STEP 1: Self-Join Matches
--   p1.email = p2.email AND p1.id > p2.id
--
--   p1.id | p1.email          | p2.id | p2.email
--   ------|-------------------|-------|------------------
--   3     | john@example.com  | 1     | john@example.com  ✅ DELETE   
--
-- STEP 2: DELETE p1
--   Removes row with id=3 (larger id)
--
-- STEP 3: Result
--   Keeps row with id=1 (smaller id)

-- =====================================================
-- AFTER DELETION:
-- =====================================================
-- id | email
-- ---|------------------
-- 1  | john@example.com  ← KEPT (smallest id)
-- 2  | bob@example.com   ← KEPT (unique)
-- =====================================================

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- DELETE with JOIN: MySQL allows DELETE while joining tables
-- Self-Join: p1 and p2 are same table for row comparison
-- p1.email = p2.email: Find duplicate emails
-- p1.id > p2.id: Keep SMALLER id, delete LARGER id
-- Execution: FROM → JOIN → Identify matches → DELETE p1

-- =====================================================
-- WHY p1.id > p2.id?
-- =====================================================
-- Determines which duplicate to keep:
--   - p1.id > p2.id → Keep smaller (p2), delete larger (p1) ✅
--   - p1.id < p2.id → Keep larger (p2), delete smaller (p1) ❌

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================
-- Given: id=1 and id=3 both have "john@example.com"
--
-- Step 1: Join finds pair where p1.id=3, p2.id=1
--         3 > 1 AND same email ✅
-- Step 2: DELETE p1 (id=3)
-- Step 3: Final table keeps id=1

-- =====================================================
-- EXTENDED EXAMPLE
-- =====================================================
-- Before:
-- id | email     | Action
-- ---|-----------|--------
-- 1  | a@b.com   | KEEP (smallest)
-- 2  | a@b.com   | DELETE
-- 3  | a@b.com   | DELETE
-- 4  | c@d.com   | KEEP (unique)
--
-- After: Only id=1 and id=4 remain

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ p1.id < p2.id (keeps larger id instead of smaller)
-- ❌ Missing email match (deletes unrelated rows)
-- ❌ Using p1.id != p2.id (deletes all duplicates)

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================