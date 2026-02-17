-- =====================================================
-- Customers Who Never Ordered Query
-- =====================================================
-- Purpose: Find customers who have never placed an order
-- Returns: Customer names with no matching order records
-- Method: LEFT JOIN with NULL check
-- =====================================================

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Customers table
CREATE TABLE Customers (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Create Orders table with foreign key reference
CREATE TABLE Orders (
    id INT PRIMARY KEY,
    customerId INT,
    FOREIGN KEY (customerId) REFERENCES Customers(id)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Customers (id, name) VALUES
(1, 'Joe'),        -- Customer without order
(2, 'Henry'),      -- Customer with order
(3, 'Sam'),        -- Customer without order
(4, 'Max');        -- Customer with order

INSERT INTO Orders (id, customerId) VALUES
(1, 2),            -- Henry's order
(2, 4);            -- Max's order

-- =====================================================
-- MAIN QUERY: LEFT JOIN with NULL CHECK
-- =====================================================

SELECT
    c.name AS Customers         -- Customer name
FROM
    Customers AS c              -- Left table (all rows included)
LEFT JOIN
    Orders AS o                 -- Right table (NULL if no match)
ON
    c.id = o.customerId         -- Join condition: match by customerId
WHERE
    o.customerId IS NULL;       -- Keep only customers with NO orders

-- =====================================================
-- HOW IT WORKS:
-- =====================================================
-- STEP 1: LEFT JOIN Operation
--   Returns ALL customers, with NULL for Orders columns
--   if no matching order exists
--
--   c.id | c.name | o.customerId
--   -----|--------|-------------
--   1    | Joe    | NULL          ← No order
--   2    | Henry  | 2             ← Has order
--   3    | Sam    | NULL          ← No order
--   4    | Max    | 4             ← Has order
--
-- STEP 2: WHERE o.customerId IS NULL
--   Filters only customers with no matching order
--
--   c.id | c.name | o.customerId
--   -----|--------|-------------
--   1    | Joe    | NULL          ✅ KEEP
--   2    | Henry  | 2             ❌ REMOVE
--   3    | Sam    | NULL          ✅ KEEP
--   4    | Max    | 4             ❌ REMOVE
--
-- STEP 3: Final Output
--   Customers |
--   ----------|
--   Joe       |
--   Sam       |

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- LEFT JOIN: Returns ALL rows from Customers (left table)
--            and matching rows from Orders (right table)
--            NULL appears in Order columns when no match found
--
-- IS NULL Check: Identifies customers with no orders
--               (WHERE o.customerId IS NULL)
--
-- Execution Order: FROM → LEFT JOIN → WHERE → SELECT

-- =====================================================
-- EXPECTED RESULT:
-- =====================================================
-- Customers |
-- ----------|
-- Joe       |
-- Sam       |
-- =====================================================

-- =====================================================
-- COMMON MISTAKE
-- =====================================================
-- ❌ Using INNER JOIN (excludes customers with no orders)
-- ✅ Use LEFT JOIN + IS NULL to capture missing relationships

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================