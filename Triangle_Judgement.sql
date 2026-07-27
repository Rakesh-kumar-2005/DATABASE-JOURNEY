-- =====================================================
-- Valid Triangle Detection Query
-- =====================================================
-- Purpose: Determine if three sides can form a valid triangle
-- Returns: All columns from Triangle table + Triangle validity status
-- Method: Triangle Inequality Theorem validation using CASE
-- Database: MS SQL Server (T-SQL)
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Triangle;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Triangle table
CREATE TABLE Triangle (
    id INT PRIMARY KEY,
    x INT NOT NULL,
    y INT NOT NULL,
    z INT NOT NULL
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Triangle (id, x, y, z) VALUES
(1, 13, 15, 20),    -- Valid triangle
(2, 10, 5, 7),      -- Invalid (10 + 5 = 15, not > 7, but 5+7=12 < 10)
(3, 3, 3, 3),       -- Valid (equilateral)
(4, 2, 2, 5),       -- Invalid (2 + 2 < 5)
(5, 7, 10, 5);      -- Valid triangle

-- =====================================================
-- MAIN QUERY
-- =====================================================

SELECT
    *,
    CASE
        WHEN x + y > z 
            AND x + z > y
            AND y + z > x
        THEN 'Yes'
        ELSE 'No'
    END AS Triangle
FROM Triangle;

-- =====================================================
-- HOW IT WORKS:
-- =====================================================
-- STEP 1: Select all columns from Triangle table
--   id | x  | y  | z
--   ---|----|----|----
--   1  | 13 | 15 | 20
--   2  | 10 | 5  | 7
--   3  | 3  | 3  | 3
--   4  | 2  | 2  | 5
--   5  | 7  | 10 | 5
--
-- STEP 2: Apply Triangle Inequality Theorem
--   For valid triangle, ALL three conditions must be true:
--   - x + y > z
--   - x + z > y
--   - y + z > x
--
-- STEP 3: Evaluate each row
--   Row 1: 13+15>20(✓) AND 13+20>15(✓) AND 15+20>13(✓) → 'Yes'
--   Row 2: 10+5>7(✓) AND 10+7>5(✓) AND 5+7>10(✓) → 'Yes' (13>10)
--   Row 3: 3+3>3(✓) AND 3+3>3(✓) AND 3+3>3(✓) → 'Yes'
--   Row 4: 2+2>5(✗) → 'No' (4 is not > 5)
--   Row 5: 7+10>5(✓) AND 7+5>10(✓) AND 10+5>7(✓) → 'Yes'
--
-- STEP 4: Final Output
--   id | x  | y  | z  | Triangle
--   ---|----|----|----|---------
--   1  | 13 | 15 | 20 | Yes
--   2  | 10 | 5  | 7  | Yes
--   3  | 3  | 3  | 3  | Yes
--   4  | 2  | 2  | 5  | No
--   5  | 7  | 10 | 5  | Yes

-- =====================================================
-- EXPECTED RESULT:
-- =====================================================
-- id | x  | y  | z  | Triangle
-- ---|----|----|----|---------
-- 1  | 13 | 15 | 20 | Yes
-- 2  | 10 | 5  | 7  | Yes
-- 3  | 3  | 3  | 3  | Yes
-- 4  | 2  | 2  | 5  | No
-- 5  | 7  | 10 | 5  | Yes
-- =====================================================

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- Triangle Inequality Theorem:
--   Sum of any two sides must be GREATER than the third side
--   NOT equal (>, not >=)
--   ALL three conditions must be satisfied
--
-- CASE Statement:
--   WHEN: Checks if all conditions are true
--   THEN: Returns 'Yes' if valid
--   ELSE: Returns 'No' if any condition fails
--
-- AND Operator:
--   All three comparisons must evaluate to TRUE
--   If ANY comparison is FALSE, result is 'No'

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================

-- Example 1: x=13, y=15, z=20 (Valid)
--   13 + 15 > 20? → 28 > 20 ✅
--   13 + 20 > 15? → 33 > 15 ✅
--   15 + 20 > 13? → 35 > 13 ✅
--   Result: 'Yes'
--
-- Example 2: x=2, y=2, z=5 (Invalid)
--   2 + 2 > 5? → 4 > 5 ❌
--   (No need to check further)
--   Result: 'No'
--
-- Example 3: x=3, y=3, z=3 (Valid - Equilateral)
--   3 + 3 > 3? → 6 > 3 ✅
--   3 + 3 > 3? → 6 > 3 ✅
--   3 + 3 > 3? → 6 > 3 ✅
--   Result: 'Yes'

-- =====================================================
-- EDGE CASES
-- =====================================================
-- Case 1: Equilateral triangle (all sides equal)
--   x=5, y=5, z=5 → 5+5>5(✓) → 'Yes'
--
-- Case 2: Isosceles triangle (two sides equal)
--   x=5, y=5, z=7 → 5+5>7(✓) → 'Yes'
--
-- Case 3: Right triangle
--   x=3, y=4, z=5 → 3+4>5(✓) → 'Yes'
--
-- Case 4: One side too large
--   x=1, y=2, z=10 → 1+2>10(✗) → 'No'
--
-- Case 5: Degenerate triangle (sides form straight line)
--   x=1, y=2, z=3 → 1+2>3(✗) → 'No' (not >, need >)
--
-- Case 6: All sides equal to 0
--   x=0, y=0, z=0 → 0+0>0(✗) → 'No'
--
-- Case 7: Negative sides (invalid in real world)
--   x=-5, y=3, z=4 → Formula still applies (follows inequality)

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ Using >= instead of > (allows degenerate triangles)
-- ❌ Using OR instead of AND (only one condition needed, should be all three)
-- ❌ Checking only x+y > z (missing other two conditions)
-- ❌ Not returning 'Yes'/'No' as strings (case sensitivity)

-- Example of mistakes:
-- ❌ WHEN x + y >= z → Accepts 1+2=3 (not a valid triangle)
-- ❌ WHEN x + y > z OR x + z > y → True even if third fails
-- ❌ Single condition → Incomplete validation

-- =====================================================
-- ALTERNATIVE APPROACHES
-- =====================================================

-- Alternative 1: Using IIF (more concise)
-- SELECT
--     *,
--     IIF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS Triangle
-- FROM Triangle;

-- Alternative 2: Using nested CASE (harder to read)
-- SELECT
--     *,
--     CASE
--         WHEN x + y > z THEN
--             CASE
--                 WHEN x + z > y THEN
--                     CASE
--                         WHEN y + z > x THEN 'Yes'
--                         ELSE 'No'
--                     END
--                 ELSE 'No'
--             END
--         ELSE 'No'
--     END AS Triangle
-- FROM Triangle;

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- Current approach is best because:
--   ✅ Clear and readable logic
--   ✅ All three conditions visible at once
--   ✅ Easy to understand and maintain
--   ✅ Efficient execution
--   ✅ Standard CASE syntax
--
-- When to use:
--   ✅ Validate geometric data
--   ✅ Quality checks on triangle measurements
--   ✅ Data validation before processing

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================