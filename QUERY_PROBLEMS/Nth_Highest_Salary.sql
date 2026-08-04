-- =====================================================
-- Get Nth Highest Salary Function
-- =====================================================
-- Purpose: Find the Nth highest distinct salary from Employee table
-- Returns: Salary value at Nth position (NULL if doesn't exist)
-- Method: DENSE_RANK() window function with ranking
-- Database: MS SQL Server (T-SQL)
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Employee;

-- =====================================================
-- TABLE CREATION
-- =====================================================

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT NOT NULL
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Employee (id, salary) VALUES
(1, 100),      -- 4th highest
(2, 200),      -- 3rd highest
(3, 300),      -- 2nd highest (duplicate)
(4, 300),      -- 2nd highest (duplicate)
(5, 400);      -- 1st highest

-- =====================================================
-- MAIN FUNCTION
-- =====================================================
-- Ensure the CREATE FUNCTION is the only statement in its batch
GO
CREATE FUNCTION dbo.getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        SELECT MAX(salary) AS getNthHighestSalary
        FROM (
            SELECT
                salary,
                DENSE_RANK() OVER(ORDER BY salary DESC) AS rs
            FROM Employee
        ) t 
        WHERE rs = @N
    );
END
GO

-- =====================================================
-- HOW IT WORKS:
-- =====================================================
-- STEP 1: DENSE_RANK() assigns ranks to salaries
--   salary | DENSE_RANK
--   -------|------------
--   400    | 1 (highest)
--   300    | 2
--   300    | 2 (same rank for duplicate)
--   200    | 3
--   100    | 4
--
-- STEP 2: WHERE rs = @N filters for Nth rank
--   Example: @N = 2
--   300 | 2 ✅
--   300 | 2 ✅
--
-- STEP 3: MAX(salary) returns single value
--   MAX(300, 300) = 300
--
-- STEP 4: Return 300

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- DENSE_RANK(): Assigns ranks without gaps
--   - Duplicates get same rank
--   - Next rank continues sequentially (no gaps)
--   - ORDER BY salary DESC: Highest salary = Rank 1
--
-- MAX(salary): Handles duplicate ranks
--   - Returns single value (required for function)
--   - Returns NULL if rank N doesn't exist
--
-- @N: Input parameter for which rank to find

-- =====================================================
-- FUNCTION USAGE
-- =====================================================
-- SELECT dbo.getNthHighestSalary(1);  -- Returns: 400
-- SELECT dbo.getNthHighestSalary(2);  -- Returns: 300
-- SELECT dbo.getNthHighestSalary(3);  -- Returns: 200
-- SELECT dbo.getNthHighestSalary(5);  -- Returns: NULL (doesn't exist)

-- =====================================================
-- DENSE_RANK vs RANK vs ROW_NUMBER
-- =====================================================
-- salary | DENSE_RANK | RANK | ROW_NUMBER
-- -------|------------|------|------------
-- 400    | 1          | 1    | 1
-- 300    | 2          | 2    | 2
-- 300    | 2 ← Same   | 2    | 3 ← Unique
-- 200    | 3 ← No gap | 4    | 4 ← Gap
-- 100    | 4          | 5    | 5
--
-- DENSE_RANK: Best for Nth highest (no gaps) ✅
-- RANK: Creates gaps after duplicates
-- ROW_NUMBER: Every row gets unique number

-- =====================================================
-- WHY MAX() IS NECESSARY
-- =====================================================
-- Without MAX (multiple rows possible):
--   SELECT salary WHERE rs = 2
--   Result: 300, 300 ❌ Two rows
--
-- With MAX (single value):
--   SELECT MAX(salary) WHERE rs = 2
--   Result: 300 ✅ Single value

-- =====================================================
-- EXECUTION EXAMPLE
-- =====================================================
-- Call: getNthHighestSalary(2)
--
-- Step 1: Rank salaries → 400(1), 300(2), 300(2), 200(3), 100(4)
-- Step 2: Filter rs = 2 → 300, 300
-- Step 3: MAX(300, 300) → 300
-- Step 4: Return 300

-- =====================================================
-- EDGE CASES
-- =====================================================
-- N = 1: Returns 400 (highest)
-- N = 2 (with duplicates): Returns 300
-- N = 10 (doesn't exist): Returns NULL
-- N = 0 or negative: Returns NULL
-- Empty table: Returns NULL

-- =====================================================
-- COMPARISON WITH ALTERNATIVES
-- =====================================================
-- Method           | Readability | Performance | Handles Duplicates
-- -----------------|-------------|-------------|-------------------
-- DENSE_RANK       | ✅ Clear    | ✅ Good     | ✅ Yes
-- OFFSET-FETCH     | ✅ Simple   | ✅ Best     | ✅ Yes
-- COUNT Subquery   | ❌ Complex  | ❌ Slow     | ✅ Yes

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ Using RANK() (creates gaps: 1,2,2,4 instead of 1,2,2,3)
-- ❌ Forgetting MAX() (function must return single value)
-- ❌ Using ASC instead of DESC (ranks lowest first)
-- ❌ Not handling NULL for non-existent ranks

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- This DENSE_RANK() approach is recommended:
--   ✅ No gaps in ranking (1,2,3,4 not 1,2,4,5)
--   ✅ Handles duplicate salaries correctly
--   ✅ Returns NULL for invalid N
--   ✅ Clear and maintainable
--   ✅ Good performance with index on salary

-- Add index for better performance:
-- CREATE INDEX idx_salary ON Employee(salary DESC);

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================