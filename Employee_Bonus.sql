-- =====================================================
-- Employees with Bonus Less Than 1000 Query
-- =====================================================
-- Purpose: Find employees with bonus < 1000 or no bonus at all
-- Returns: Employee names and their bonus amounts (NULL if no bonus)
-- Method: LEFT JOIN with WHERE filter for low/missing bonuses
-- Database: MS SQL Server (T-SQL)
-- =====================================================

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS Bonus;
DROP TABLE IF EXISTS Employee;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Employee table
CREATE TABLE Employee (
    empId INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create Bonus table with foreign key
CREATE TABLE Bonus (
    empId INT,
    bonus INT,
    FOREIGN KEY (empId) REFERENCES Employee(empId)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Employee (empId, name) VALUES
(1, 'Joe'),
(2, 'Jim'),
(3, 'Henry'),
(4, 'Sam');

INSERT INTO Bonus (empId, bonus) VALUES
(1, 500),      -- Less than 1000 ✅
(2, 2000),     -- Greater than 1000 ❌
(4, 800);      -- Less than 1000 ✅
-- Henry (empId 3) has no bonus

-- =====================================================
-- MAIN QUERY
-- =====================================================

SELECT
    E.name,
    B.bonus
FROM Employee E
LEFT JOIN Bonus B
    ON E.empId = B.empId
WHERE B.bonus < 1000 OR B.bonus IS NULL;

-- =====================================================
-- HOW IT WORKS:
-- =====================================================
-- STEP 1: LEFT JOIN Employee with Bonus
--   Returns ALL employees with bonus data (NULL if no bonus)
--
--   E.empId | E.name  | B.empId | B.bonus
--   --------|---------|---------|--------
--   1       | Joe     | 1       | 500
--   2       | Jim     | 2       | 2000
--   3       | Henry   | NULL    | NULL  ← No bonus record
--   4       | Sam     | 4       | 800
--
-- STEP 2: WHERE B.bonus < 1000 OR B.bonus IS NULL
--   Keeps only employees with:
--   - Bonus < 1000 (includes 500, 800)
--   - OR no bonus (NULL values)
--
--   E.empId | E.name  | B.bonus
--   --------|---------|--------
--   1       | Joe     | 500      ✅ (< 1000)
--   3       | Henry   | NULL     ✅ (IS NULL)
--   4       | Sam     | 800      ✅ (< 1000)
--   
--   Jim (2000) excluded ❌

-- =====================================================
-- EXPECTED RESULT:
-- =====================================================
-- name   | bonus
-- -------|-------
-- Joe    | 500
-- Henry  | NULL
-- Sam    | 800
-- =====================================================

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- LEFT JOIN: Returns ALL rows from Employee (left table)
--   - Bonus data included if exists
--   - NULL for bonus columns if no matching record
--
-- B.bonus < 1000: Filters for bonuses below 1000
--
-- B.bonus IS NULL: Catches employees with no bonus
--   - Important: Cannot use B.bonus = NULL (always false)
--   - Must use IS NULL keyword
--
-- OR operator: Includes rows matching either condition
--   - (bonus < 1000) OR (bonus IS NULL)

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================

-- Given Data:
-- Employee: Joe(1), Jim(2), Henry(3), Sam(4)
-- Bonus: Joe(500), Jim(2000), Sam(800), Henry(none)

-- Step 1: LEFT JOIN all employees with bonuses
--   Joe→500, Jim→2000, Henry→NULL, Sam→800

-- Step 2: Apply WHERE filter
--   Joe: 500 < 1000? YES ✅
--   Jim: 2000 < 1000? NO, 2000 IS NULL? NO ❌
--   Henry: NULL < 1000? NO, NULL IS NULL? YES ✅
--   Sam: 800 < 1000? YES ✅

-- Step 3: Final Result
--   Joe(500), Henry(NULL), Sam(800)

-- =====================================================
-- LEFT JOIN vs INNER JOIN
-- =====================================================

-- LEFT JOIN (Current):
--   Includes ALL employees
--   Employees without bonus show NULL
--   Henry is included (has no bonus record)
--
-- INNER JOIN (Alternative):
--   Only employees with bonus records
--   Henry would be excluded (no bonus record)
--
-- Result with INNER JOIN:
--   name   | bonus
--   -------|-------
--   Joe    | 500
--   Sam    | 800
--   (Henry excluded)

-- In this query:
--   LEFT JOIN is correct → Finds employees with low/no bonus
--   INNER JOIN would miss those with NO bonus

-- =====================================================
-- WHY IS NULL IS NECESSARY
-- =====================================================

-- ❌ WRONG: WHERE B.bonus = NULL
--   Result: Returns 0 rows (NULL = NULL is unknown, not true)
--
-- ✅ CORRECT: WHERE B.bonus IS NULL
--   Result: Returns employees without bonus record
--
-- In SQL: NULL is special value meaning "unknown"
--   - Cannot use = with NULL
--   - Must use IS NULL or IS NOT NULL

-- =====================================================
-- WHERE CLAUSE CONDITIONS
-- =====================================================

-- Current (B.bonus < 1000 OR B.bonus IS NULL):
--   Includes: 500, 800, NULL ✅
--
-- Alternative 1 (B.bonus <= 1000):
--   Problem: Excludes NULL values ❌
--   Result: Only 500, 800 (not Henry)
--
-- Alternative 2 (B.bonus IS NULL OR B.bonus < 1000):
--   Same as current (order doesn't matter) ✅
--   Result: NULL, 500, 800

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ Using INNER JOIN (excludes employees with no bonus)
-- ❌ Using B.bonus = NULL (returns no results)
-- ❌ Using B.bonus <= 1000 (excludes NULL values)
-- ❌ Forgetting IS NULL (misses employees without bonus)
-- ❌ Using AND instead of OR (returns no results)

-- Example of AND mistake:
-- WHERE B.bonus < 1000 AND B.bonus IS NULL
-- Problem: No value is both < 1000 AND NULL (impossible) ❌

-- =====================================================
-- VARIATIONS
-- =====================================================

-- Variation 1: Only employees with NO bonus
-- WHERE B.bonus IS NULL;
-- Result: Henry

-- Variation 2: Only employees with bonus (any amount)
-- WHERE B.bonus IS NOT NULL;
-- Result: Joe(500), Jim(2000), Sam(800)

-- Variation 3: Employees with bonus >= 1000
-- WHERE B.bonus >= 1000;
-- Result: Jim(2000)

-- Variation 4: Employees with NO bonus or high bonus
-- WHERE B.bonus IS NULL OR B.bonus >= 1000;
-- Result: Henry(NULL), Jim(2000)

-- =====================================================
-- EDGE CASES
-- =====================================================

-- Case 1: Employee with bonus = 1000 (exactly)
--   WHERE B.bonus < 1000: FALSE ❌ (1000 is not < 1000)
--   Would be excluded from result
--
-- Case 2: Employee with bonus = 0
--   WHERE B.bonus < 1000: TRUE ✅
--   Would be included
--
-- Case 3: No bonus records exist
--   Result: All employees (all have NULL bonus)
--
-- Case 4: All employees have bonus >= 1000
--   Result: Only employees with NULL bonus

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- This query is good because:
--   ✅ Uses LEFT JOIN (includes all employees)
--   ✅ Uses IS NULL (correct NULL handling)
--   ✅ Clear WHERE conditions
--   ✅ Finds low bonuses and missing bonuses
--
-- Performance tips:
--   CREATE INDEX idx_empId ON Bonus(empId);
--   - Speeds up JOIN operation
--
-- When to use:
--   ✅ HR audits (find who got < 1000 bonus)
--   ✅ Bonus review process
--   ✅ Finding employees needing bonus adjustment

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================