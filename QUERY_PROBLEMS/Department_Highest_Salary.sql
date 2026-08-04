-- ==========================================================================================
-- Department Top Salary Query
-- ==========================================================================================
-- Purpose: Find employees with highest salary in each department
-- Returns: Department name, employee name, and their salary
-- Methods: Subquery approach and CTE (Common Table Expression) approach
-- Database: MS SQL Server (T-SQL)
-- ==========================================================================================

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- ==========================================================================================
-- TABLE CREATION
-- ==========================================================================================

-- Create Department table
CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create Employee table with foreign key
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary INT NOT NULL,
    departmentId INT,
    FOREIGN KEY (departmentId) REFERENCES Department(id)
);

-- ==========================================================================================
-- SAMPLE DATA INSERTION
-- ==========================================================================================

INSERT INTO Department (id, name) VALUES
(1, 'IT'),
(2, 'Sales'),
(3, 'HR');

INSERT INTO Employee (id, name, salary, departmentId) VALUES
(1, 'Joe', 85000, 1),      -- IT: 2nd highest
(2, 'Jim', 90000, 1),      -- IT: Highest (tie)
(3, 'Henry', 80000, 2),    -- Sales: Highest
(4, 'Sam', 60000, 2),      -- Sales: Lower
(5, 'Max', 90000, 1),      -- IT: Highest (tie)
(6, 'Randy', 85000, 1);    -- IT: 2nd highest (tie)

-- ==========================================================================================
-- SOLUTION 1: BRUTE FORCE (SUBQUERY APPROACH)
-- ==========================================================================================
-- Uses subquery to rank employees, then filters in outer query
-- ==========================================================================================

SELECT
    Department,
    Employee,
    Salary
FROM (
    SELECT
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rk
    FROM Department AS d
    LEFT JOIN Employee AS e
        ON e.departmentId = d.id
) t
WHERE rk = 1 AND Salary IS NOT NULL;

-- ==========================================================================================
-- HOW SOLUTION 1 WORKS:
-- ==========================================================================================
-- STEP 1: LEFT JOIN Department with Employee
--   d.id | d.name | e.name | e.salary | e.departmentId
--   -----|--------|--------|----------|----------------
--   1    | IT     | Joe    | 85000    | 1
--   1    | IT     | Jim    | 90000    | 1
--   1    | IT     | Max    | 90000    | 1
--   1    | IT     | Randy  | 85000    | 1
--   2    | Sales  | Henry  | 80000    | 2
--   2    | Sales  | Sam    | 60000    | 2
--   3    | HR     | NULL   | NULL     | NULL
--
-- STEP 2: RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC)
--   Department | Employee | Salary | rk
--   -----------|----------|--------|----
--   IT         | Jim      | 90000  | 1 ← Highest
--   IT         | Max      | 90000  | 1 ← Highest (tie)
--   IT         | Joe      | 85000  | 3
--   IT         | Randy    | 85000  | 3
--   Sales      | Henry    | 80000  | 1 ← Highest
--   Sales      | Sam      | 60000  | 2
--   HR         | NULL     | NULL   | NULL
--
-- STEP 3: WHERE rk = 1 AND Salary IS NOT NULL
--   Department | Employee | Salary
--   -----------|----------|--------
--   IT         | Jim      | 90000  ✅
--   IT         | Max      | 90000  ✅
--   Sales      | Henry    | 80000  ✅

-- ==========================================================================================
-- KEY CONCEPTS (Solution 1):
-- ==========================================================================================
-- RANK() OVER: Window function for ranking
-- PARTITION BY e.departmentId: Separate ranking per department
-- ORDER BY e.salary DESC: Highest salary gets rank 1
-- LEFT JOIN: Includes departments without employees
-- Subquery: Inner query creates ranked dataset, outer filters
-- WHERE rk = 1: Keeps only top-ranked employees
-- Salary IS NOT NULL: Excludes departments with no employees

-- ==========================================================================================
-- ==========================================================================================
-- ==========================================================================================

-- ==========================================================================================
-- SOLUTION 2: OPTIMIZED WITH CTE (RECOMMENDED)
-- ==========================================================================================
-- Uses Common Table Expression for better readability
-- Filters NULL salaries earlier for efficiency
-- ==========================================================================================

WITH RankedEmployees AS (
    SELECT
        d.name AS Department,
        e.name AS Employee,
        e.salary AS Salary,
        RANK() OVER (
            PARTITION BY e.departmentId 
            ORDER BY e.salary DESC
        ) AS rk
    FROM Department AS d
    LEFT JOIN Employee AS e
        ON e.departmentId = d.id
    WHERE e.salary IS NOT NULL  -- Filter early (optimization)
)
SELECT 
    Department,
    Employee,
    Salary
FROM RankedEmployees
WHERE rk = 1;

-- ==========================================================================================
-- HOW SOLUTION 2 WORKS:
-- ==========================================================================================
-- STEP 1: CTE (WITH clause) creates temporary named result set
--   Same ranking logic as Solution 1
--   WHERE e.salary IS NOT NULL filters before ranking
--
-- Intermediate CTE Result:
--   Department | Employee | Salary | rk
--   -----------|----------|--------|----
--   IT         | Jim      | 90000  | 1
--   IT         | Max      | 90000  | 1
--   IT         | Joe      | 85000  | 3
--   IT         | Randy    | 85000  | 3
--   Sales      | Henry    | 80000  | 1
--   Sales      | Sam      | 60000  | 2
--
-- STEP 2: Main SELECT filters rk = 1
--   Department | Employee | Salary
--   -----------|----------|--------
--   IT         | Jim      | 90000  ✅
--   IT         | Max      | 90000  ✅
--   Sales      | Henry    | 80000  ✅

-- ==========================================================================================
-- KEY CONCEPTS (Solution 2):
-- ==========================================================================================
-- CTE (Common Table Expression): Named temporary result set
--   - Syntax: WITH name AS (query)
--   - Improves readability and maintainability
--   - Can be referenced multiple times
--
-- Early Filtering: WHERE e.salary IS NOT NULL in CTE
--   - Filters before ranking (more efficient)
--   - Reduces rows processed by window function
--
-- Same ranking logic as Solution 1
-- Cleaner separation of ranking and filtering logic

-- ==========================================================================================
-- COMPARISON: SOLUTION 1 vs SOLUTION 2
-- ==========================================================================================

-- Feature              | Solution 1 (Subquery) | Solution 2 (CTE)
-- ---------------------|----------------------|-------------------
-- Readability          | ❌ Less clear        | ✅ More clear
-- Maintainability      | ❌ Harder to modify  | ✅ Easier to modify
-- Performance          | ⚠️ Filters late      | ✅ Filters early
-- Reusability          | ❌ Can't reuse       | ✅ Can reference CTE
-- Code Organization    | ❌ Nested            | ✅ Sequential
-- Debugging            | ❌ Harder            | ✅ Easier
-- Best Practice        | ❌ Not recommended   | ✅ Recommended

-- ==========================================================================================
-- EXPECTED RESULT (BOTH SOLUTIONS):
-- ==========================================================================================
-- Department | Employee | Salary
-- -----------|----------|--------
-- IT         | Jim      | 90000
-- IT         | Max      | 90000
-- Sales      | Henry    | 80000
-- ==========================================================================================

-- Explanation:
-- IT: Jim and Max both earn 90,000 (highest, tied for rank 1)
-- Sales: Henry earns 80,000 (highest in Sales)
-- HR: No employees (excluded by IS NOT NULL filter)

-- ==========================================================================================
-- RANK() OVER PARTITION BY EXPLAINED
-- ==========================================================================================

-- PARTITION BY e.departmentId:
--   Creates separate ranking "windows" for each department
--   Rank resets to 1 for each new department
--
-- Without PARTITION BY (wrong):
--   All employees ranked together across all departments
--   
-- With PARTITION BY (correct):
--   IT department: Ranks 1, 1, 3, 3
--   Sales department: Ranks 1, 2
--   Each department has independent ranking

-- ORDER BY e.salary DESC:
--   Highest salary gets rank 1 within each partition
--   DESC = Descending (largest to smallest)

-- ==========================================================================================
-- RANK() vs DENSE_RANK() vs ROW_NUMBER()
-- ==========================================================================================

-- Example within IT department:
-- Employee | Salary | RANK() | DENSE_RANK() | ROW_NUMBER()
-- ---------|--------|--------|--------------|-------------
-- Jim      | 90000  | 1      | 1            | 1
-- Max      | 90000  | 1      | 1            | 2
-- Joe      | 85000  | 3 ← Gap| 2 ← No gap  | 3
-- Randy    | 85000  | 3      | 2            | 4
--
-- RANK(): Has gaps after ties (1,1,3,3) ✅ Used here
-- DENSE_RANK(): No gaps (1,1,2,2)
-- ROW_NUMBER(): All unique (1,2,3,4)

-- ==========================================================================================
-- WHY LEFT JOIN?
-- ==========================================================================================

-- LEFT JOIN: Includes ALL departments
--   - Departments with employees: Show employee data
--   - Departments without employees: Show NULL
--
-- INNER JOIN (alternative):
--   - Only shows departments that have employees
--   - HR would be completely excluded
--
-- In this query:
--   LEFT JOIN used but NULL filtered out anyway
--   Could use INNER JOIN for same result

-- ==========================================================================================
-- EXECUTION BREAKDOWN
-- ==========================================================================================

-- Given Data:
-- Departments: IT, Sales, HR
-- Employees: Jim(90k,IT), Max(90k,IT), Joe(85k,IT), 
--            Randy(85k,IT), Henry(80k,Sales), Sam(60k,Sales)

-- Step 1: Join Department + Employee
-- Step 2: Rank within each department
--   IT: Jim=1, Max=1, Joe=3, Randy=3
--   Sales: Henry=1, Sam=2
--   HR: NULL (no employees)
-- Step 3: Filter rk = 1 AND salary IS NOT NULL
--   Result: Jim, Max, Henry

-- ==========================================================================================
-- COMMON MISTAKES
-- ==========================================================================================
-- ❌ Forgetting PARTITION BY (ranks all employees together)
-- ❌ Using INNER JOIN without realizing it excludes empty departments
-- ❌ Not filtering NULL salaries (includes empty departments in result)
-- ❌ Using ROW_NUMBER() instead of RANK() (loses tie information)
-- ❌ Forgetting DESC (ranks lowest salary as #1)

-- ==========================================================================================
-- RECOMMENDATION
-- ==========================================================================================
-- Use SOLUTION 2 (CTE approach) because:
--   ✅ More readable and maintainable
--   ✅ Better performance (early NULL filtering)
--   ✅ Easier to debug and modify
--   ✅ Industry best practice
--   ✅ Can reuse CTE if needed
--   ✅ Clear separation of concerns

-- Performance tip:
--   CREATE INDEX idx_dept_salary ON Employee(departmentId, salary DESC);

-- ==========================================================================================
-- END OF DOCUMENTATION
-- ==========================================================================================