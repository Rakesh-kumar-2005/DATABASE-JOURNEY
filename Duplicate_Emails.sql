-- =====================================================
-- Duplicate Email Detection Query
-- =====================================================
-- Purpose: Find all duplicate email addresses in Person table
-- Returns: Email addresses that appear more than once
-- Methods: GROUP BY with HAVING, and Self-Join with DISTINCT
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

-- Insert sample persons (with duplicate emails)
INSERT INTO Person (id, email) VALUES
(1, 'a@b.com'),        -- Duplicate email (appears 2 times)
(2, 'c@d.com'),        -- Unique email
(3, 'a@b.com'),        -- Duplicate email (same as id 1)
(4, 'e@f.com'),        -- Duplicate email (appears 3 times)
(5, 'e@f.com'),        -- Duplicate email (same as id 4)
(6, 'e@f.com');        -- Duplicate email (same as id 4, 5)

-- =====================================================
-- SOLUTION 1: GROUP BY with HAVING (RECOMMENDED)
-- =====================================================
-- Uses aggregation to count occurrences of each email
-- Filters groups with count > 1
-- =====================================================

SELECT
    p.email AS Email            -- Email address
FROM 
    Person AS p                 -- Person table
GROUP BY
    p.email                     -- Group rows by email address
HAVING
    COUNT(*) > 1;              -- Keep only groups with more than 1 row

-- =====================================================
-- HOW SOLUTION 1 WORKS:
-- =====================================================
-- STEP 1: GROUP BY Operation
--   Groups all rows by email address
--
-- Grouped Data:
--   email     | COUNT(*)
--   ----------|----------
--   a@b.com   | 2
--   c@d.com   | 1
--   e@f.com   | 3
--
-- STEP 2: HAVING Clause Filter
--   Filters groups WHERE COUNT(*) > 1
--
-- Results after HAVING:
--   email     | COUNT(*)
--   ----------|----------
--   a@b.com   | 2        ✅ KEEP
--   c@d.com   | 1        ❌ REMOVE
--   e@f.com   | 3        ✅ KEEP
--
-- STEP 3: Final Output
--   Email     |
--   ----------|
--   a@b.com   |
--   e@f.com   |

-- =====================================================
-- KEY CONCEPTS (Solution 1):
-- =====================================================
-- GROUP BY: Combines rows with same email into groups
-- COUNT(*): Counts number of rows in each group
-- HAVING: Filters groups after aggregation (unlike WHERE which filters before)
-- Execution Order: FROM → GROUP BY → COUNT(*) → HAVING → SELECT

-- =====================================================
-- =====================================================
-- =====================================================


-- =====================================================
-- SOLUTION 2: SELF-JOIN with DISTINCT
-- =====================================================
-- Joins Person table to itself to find matching emails
-- Uses DISTINCT to eliminate duplicate results
-- =====================================================

SELECT DISTINCT
    p1.email AS Email           -- Email from first instance
FROM
    Person AS p1                -- First instance of Person table
JOIN
    Person AS p2                -- Second instance of Person table
ON
    p1.email = p2.email         -- Match rows with same email
    AND p1.id != p2.id;         -- Exclude matching same row to itself

-- =====================================================
-- HOW SOLUTION 2 WORKS:
-- =====================================================
-- STEP 1: Self-Join with Conditions
--   p1.email = p2.email → Find rows with same email
--   p1.id != p2.id → Prevent row from matching itself
--
-- Join Results (Before DISTINCT):
--   p1.id | p1.email  | p2.id | p2.email
--   ------|-----------|-------|----------
--   1     | a@b.com   | 3     | a@b.com   ✅
--   3     | a@b.com   | 1     | a@b.com   ✅ (reverse pair)
--   4     | e@f.com   | 5     | e@f.com   ✅
--   4     | e@f.com   | 6     | e@f.com   ✅
--   5     | e@f.com   | 4     | e@f.com   ✅
--   5     | e@f.com   | 6     | e@f.com   ✅
--   6     | e@f.com   | 4     | e@f.com   ✅
--   6     | e@f.com   | 5     | e@f.com   ✅
--
-- Note: c@d.com not in results (no duplicate found)
--
-- STEP 2: DISTINCT Removes Duplicate Emails
--   Before: a@b.com, a@b.com, e@f.com, e@f.com, e@f.com...
--   After: a@b.com, e@f.com
--
-- STEP 3: Final Output
--   Email     |
--   ----------|
--   a@b.com   |
--   e@f.com   |

-- =====================================================
-- KEY CONCEPTS (Solution 2):
-- =====================================================
-- Self-Join: Table joined to itself with different aliases (p1, p2)
-- p1.email = p2.email: Finds rows with matching emails
-- p1.id != p2.id: Critical - prevents row from matching itself
-- DISTINCT: Removes duplicate emails (pairs appear twice: p1→p2 and p2→p1)
-- Execution Order: FROM p1, p2 → JOIN ON conditions → SELECT → DISTINCT

-- =====================================================
-- COMPARISON: SOLUTION 1 vs SOLUTION 2
-- =====================================================

-- Feature              | Solution 1 (GROUP BY) | Solution 2 (Self-Join)
-- ---------------------|-----------------------|------------------------
-- Readability          | ✅ Clear              | ❌ Complex
-- Performance (large)  | ✅ Faster O(n)        | ❌ Slower O(n²)
-- Memory Usage         | ✅ Lower              | ❌ Higher
-- Simplicity           | ✅ Simple             | ❌ More complex
-- Needs DISTINCT       | ❌ No                 | ✅ Yes
-- Best Practice        | ✅ Recommended        | ❌ Not recommended

-- =====================================================
-- EXPECTED RESULT (BOTH SOLUTIONS):
-- =====================================================
-- Email     |
-- ----------|
-- a@b.com   |
-- e@f.com   |
-- =====================================================

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================

-- Given Data:
-- id | email
-- ---|----------
-- 1  | a@b.com
-- 2  | c@d.com
-- 3  | a@b.com
-- 4  | e@f.com
-- 5  | e@f.com
-- 6  | e@f.com

-- SOLUTION 1: GROUP BY p.email → COUNT(*) → HAVING COUNT(*) > 1
--   a@b.com: 2 > 1 ✅ | c@d.com: 1 > 1 ❌ | e@f.com: 3 > 1 ✅

-- SOLUTION 2: Join pairs → SELECT p1.email → DISTINCT
--   Pairs: (1,3), (3,1), (4,5), (4,6), (5,4), (5,6), (6,4), (6,5)
--   Before DISTINCT: a@b.com, a@b.com, e@f.com, e@f.com...
--   After DISTINCT: a@b.com, e@f.com

-- =====================================================
-- WHERE vs HAVING
-- =====================================================
-- WHERE: Filters ROWS before grouping (cannot use COUNT, SUM, etc.)
-- HAVING: Filters GROUPS after grouping (can use aggregate functions)
--
-- ❌ WRONG: WHERE COUNT(*) > 1  (Cannot use aggregates in WHERE)
-- ✅ CORRECT: HAVING COUNT(*) > 1

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- 1. Using WHERE instead of HAVING with COUNT(*)
-- 2. Forgetting DISTINCT in self-join solution
-- 3. Missing p1.id != p2.id (returns all emails, not just duplicates)

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- Use SOLUTION 1 (GROUP BY with HAVING) because:
--   ✅ Simpler logic and clearer intent
--   ✅ Better performance (especially on large datasets)
--   ✅ Lower memory usage
--   ✅ No need for DISTINCT
--   ✅ Industry standard for duplicate detection

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================