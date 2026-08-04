-- =====================================================
-- Employee Salary Comparison Query
-- =====================================================
-- Purpose: Identify employees who earn more than their managers
-- Returns: Employee names where employee.salary > manager.salary
-- Method: Self-join on the Employee table
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Employee;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Employee table with self-referencing foreign key
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary INT,
    managerId INT,
    FOREIGN KEY (managerId) REFERENCES Employee(id)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert sample employees and managers
INSERT INTO Employee (id, name, salary, managerId) VALUES
(1, 'Joe', 70000, 3),      -- Employee earning MORE than manager (Sam)
(2, 'Henry', 80000, 4),    -- Employee earning LESS than manager (Max)
(3, 'Sam', 60000, NULL),   -- Top-level manager (Joe's manager)
(4, 'Max', 90000, NULL);   -- Top-level manager (Henry's manager)

-- =====================================================
-- SOLUTION 1: EXPLICIT JOIN SYNTAX (RECOMMENDED)
-- =====================================================
-- Modern SQL-92+ standard with clear join logic
-- Separates join conditions (ON) from filters (WHERE)
-- =====================================================

SELECT
    e.name AS Employee          -- Employee name (aliased for output)
FROM 
    Employee AS e               -- e = Employee table (represents employees)
JOIN
    Employee AS m               -- m = Employee table (represents managers)
ON 
    e.managerId = m.id          -- Join condition: match employee to manager
WHERE
    e.salary > m.salary;        -- Filter: employee earns more than manager

-- =====================================================
-- HOW SOLUTION 1 WORKS:
-- =====================================================
-- STEP 1: Self-Join
--   - Employee table is joined to itself using aliases 'e' and 'm'
--   - 'e' represents employees, 'm' represents managers
--   - ON clause links: e.managerId = m.id
--
-- STEP 2: Join Results (Before WHERE filter):
--   e.id | e.name | e.salary | e.managerId | m.id | m.name | m.salary
--   -----|--------|----------|-------------|------|--------|----------
--   1    | Joe    | 70000    | 3           | 3    | Sam    | 60000
--   2    | Henry  | 80000    | 4           | 4    | Max    | 90000
--
-- STEP 3: WHERE Filtering
--   - Joe: 70000 > 60000 ✅ INCLUDED
--   - Henry: 80000 > 90000 ❌ EXCLUDED
--
-- STEP 4: Final Output
--   Employee |
--   ---------|
--   Joe      |

-- =====================================================
-- KEY CONCEPTS (Solution 1):
-- =====================================================
-- 1. INNER JOIN (implicit): Only returns rows with matches
--    - Employees without managers (managerId = NULL) excluded
--
-- 2. ON Clause: Specifies join condition
--    - Determines HOW tables are linked
--
-- 3. WHERE Clause: Filters the joined results
--    - Determines WHICH rows to keep after joining
--
-- 4. Clear Separation: Join logic (ON) vs Filter logic (WHERE)
--    - More readable and maintainable
--    - Easier to debug and modify

-- =====================================================
-- =====================================================

SELECT
'================================================================'
    

-- =====================================================
-- SOLUTION 2: COMMA JOIN SYNTAX (LEGACY)
-- =====================================================
-- Pre-SQL-92 syntax using comma-separated tables
-- Join condition placed in WHERE clause
-- =====================================================

SELECT
    e.name AS Employee          -- Employee name
FROM
    Employee e,                 -- e = Employee table (employees)
    Employee m                  -- m = Employee table (managers)
WHERE
    e.managerId = m.id          -- Join condition (in WHERE clause)
    AND e.salary > m.salary;    -- Salary comparison filter

-- =====================================================
-- HOW SOLUTION 2 WORKS:
-- =====================================================
-- STEP 1: Cartesian Product
--   - FROM Employee e, Employee m creates ALL combinations
--   - If Employee has 4 rows, creates 4 × 4 = 16 combinations
--
-- STEP 2: Cartesian Product Result (Partial):
--   e.id | e.name | e.managerId | m.id | m.name
--   -----|--------|-------------|------|--------
--   1    | Joe    | 3           | 1    | Joe
--   1    | Joe    | 3           | 2    | Henry
--   1    | Joe    | 3           | 3    | Sam      ✅ Match
--   1    | Joe    | 3           | 4    | Max
--   2    | Henry  | 4           | 1    | Joe
--   2    | Henry  | 4           | 2    | Henry
--   2    | Henry  | 4           | 3    | Sam
--   2    | Henry  | 4           | 4    | Max      ✅ Match
--   ... (16 total combinations)
--
-- STEP 3: WHERE Filtering
--   - First condition: e.managerId = m.id (join logic)
--     Reduces 16 combinations to 2 matches
--   
--   - Second condition: e.salary > m.salary (filter logic)
--     Further reduces to final result
--
-- STEP 4: Final Output
--   Employee |
--   ---------|
--   Joe      |

-- =====================================================
-- KEY CONCEPTS (Solution 2):
-- =====================================================
-- 1. Comma Join: Old-style implicit join syntax
--    - Creates Cartesian product first
--    - Then filters in WHERE clause
--
-- 2. WHERE Clause: Combines join condition AND filter
--    - e.managerId = m.id (join logic)
--    - e.salary > m.salary (filter logic)
--    - Both conditions connected by AND
--
-- 3. Same Result, Different Approach:
--    - Database optimizer creates same execution plan
--    - Performance identical to Solution 1
--
-- 4. Less Readable:
--    - Join logic mixed with filter logic
--    - Harder to distinguish purpose of each condition
--    - Not recommended for modern SQL code

-- =====================================================
-- COMPARISON: SOLUTION 1 vs SOLUTION 2
-- =====================================================

-- Feature              | Solution 1 (JOIN...ON) | Solution 2 (Comma, WHERE)
-- ---------------------|------------------------|---------------------------
-- SQL Standard         | SQL-92+ (Modern)       | Pre-SQL-92 (Legacy)
-- Readability          | ✅ High                | ❌ Lower
-- Join Logic Location  | ON clause              | WHERE clause
-- Filter Logic         | WHERE clause           | WHERE clause (mixed)
-- Separation           | ✅ Clear               | ❌ Mixed
-- Performance          | Same                   | Same
-- Maintainability      | ✅ Easier              | ❌ Harder
-- Best Practice        | ✅ Recommended         | ❌ Not recommended

-- =====================================================
-- EXPECTED RESULT (BOTH SOLUTIONS):
-- =====================================================
-- Employee |
-- ---------|
-- Joe      |
-- =====================================================

-- Explanation:
-- - Joe earns $70,000, his manager Sam earns $60,000
-- - Joe earns MORE than his manager ✅ INCLUDED
--
-- - Henry earns $80,000, his manager Max earns $90,000
-- - Henry earns LESS than his manager ❌ EXCLUDED
--
-- - Sam has no manager (managerId = NULL) ❌ EXCLUDED
-- - Max has no manager (managerId = NULL) ❌ EXCLUDED

-- =====================================================
-- KEY SQL CONCEPTS
-- =====================================================

-- CONCEPT 1: Self-Join
-- --------------------
-- Definition: Joining a table to itself using different aliases
--
-- Why needed?
--   - Manager information is stored in the same table
--   - Need to compare employee data with their manager's data
--   - Aliases (e, m) create two "virtual" instances
--
-- Pattern:
--   FROM TableName AS Alias1
--   JOIN TableName AS Alias2 ON Alias1.foreignKey = Alias2.primaryKey

-- CONCEPT 2: Table Aliases
-- -------------------------
-- e = Employee instance (represents employees)
-- m = Manager instance (represents managers, same table)
--
-- Without aliases:
--   ❌ Cannot reference the same table twice
--   ❌ Cannot distinguish employee vs manager columns
--
-- With aliases:
--   ✅ e.salary refers to employee's salary
--   ✅ m.salary refers to manager's salary

-- CONCEPT 3: INNER JOIN Behavior
-- -------------------------------
-- Both solutions use INNER JOIN (explicit in Sol 1, implicit in Sol 2)
--
-- Characteristics:
--   - Returns only rows with matches in BOTH table instances
--   - Employees without managers (managerId = NULL) are excluded
--   - No NULL handling needed in this query
--   - Result set contains only valid employee-manager pairs

-- CONCEPT 4: Join Condition
-- --------------------------
-- e.managerId = m.id
--
-- Purpose:
--   - Links each employee record to their manager record
--   - Creates the employee-manager relationship
--   - Foundation for salary comparison
--
-- Example:
--   Joe (e.managerId = 3) → Sam (m.id = 3)
--   Henry (e.managerId = 4) → Max (m.id = 4)

-- CONCEPT 5: Filter Condition
-- ----------------------------
-- e.salary > m.salary
--
-- Purpose:
--   - Filters joined results to desired subset
--   - Keeps only employees earning more than their manager
--   - Applied AFTER the join operation

-- =====================================================
-- EXECUTION BREAKDOWN (Step by Step)
-- =====================================================

-- Given Data:
-- -----------
-- id | name   | salary | managerId
-- ---|--------|--------|----------
-- 1  | Joe    | 70000  | 3
-- 2  | Henry  | 80000  | 4
-- 3  | Sam    | 60000  | NULL
-- 4  | Max    | 90000  | NULL

-- Step 1: Self-Join Operation
-- ----------------------------
-- Match employees (e) with managers (m) using e.managerId = m.id
--
-- Result after join:
-- e.id | e.name | e.salary | e.managerId | m.id | m.name | m.salary
-- -----|--------|----------|-------------|------|--------|----------
-- 1    | Joe    | 70000    | 3           | 3    | Sam    | 60000
-- 2    | Henry  | 80000    | 4           | 4    | Max    | 90000
--
-- Note: Sam and Max excluded (no matching managerId)

-- Step 2: Apply WHERE Filter (e.salary > m.salary)
-- -------------------------------------------------
-- Row 1: Joe (70000) > Sam (60000)? YES ✅ KEEP
-- Row 2: Henry (80000) > Max (90000)? NO ❌ REMOVE

-- Step 3: Select Output Columns
-- ------------------------------
-- SELECT e.name AS Employee
--
-- Final Result:
-- Employee |
-- ---------|
-- Joe      |

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- Use SOLUTION 1 (JOIN...ON syntax) because:
--   ✅ Industry standard (SQL-92+)
--   ✅ Better readability
--   ✅ Clear separation of concerns
--   ✅ Easier to maintain and debug
--   ✅ Preferred in professional environments
--   ✅ Works with all modern join types (LEFT, RIGHT, FULL)
--
-- Avoid SOLUTION 2 (Comma syntax) because:
--   ❌ Outdated style
--   ❌ Mixed join and filter logic
--   ❌ Harder to read and maintain
--   ❌ Can be confusing for complex queries
--   ❌ Limited to simple equi-joins

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================