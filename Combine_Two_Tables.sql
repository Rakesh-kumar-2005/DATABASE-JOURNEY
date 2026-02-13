-- =====================================================
-- Person and Address Query with LEFT JOIN
-- =====================================================
-- Purpose: Retrieve all persons with their address information
-- Returns: firstName, lastName, city, state for ALL persons
-- Note: Persons without addresses will have NULL for city/state
-- =====================================================

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS Address;
DROP TABLE IF EXISTS Person;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Person table
CREATE TABLE Person (
    personId INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL
);

-- Create Address table with foreign key reference
CREATE TABLE Address (
    addressId INT PRIMARY KEY AUTO_INCREMENT,
    personId INT,
    city VARCHAR(100),
    state VARCHAR(50),
    FOREIGN KEY (personId) REFERENCES Person(personId)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert sample persons
INSERT INTO Person (personId, firstName, lastName) VALUES
(1, 'Wang', 'Allen'),      -- Person without address
(2, 'Alice', 'Bob'),        -- Person with address
(3, 'John', 'Doe'),         -- Person with address
(4, 'Jane', 'Smith'),       -- Person without address
(5, 'Michael', 'Johnson');  -- Person with address

-- Insert sample addresses (note: personId 1 and 4 have no addresses)
INSERT INTO Address (addressId, personId, city, state) VALUES
(1, 2, 'New York City', 'New York'),
(2, 3, 'Los Angeles', 'California'),
(3, 5, 'Chicago', 'Illinois');

-- =====================================================
-- MAIN QUERY: LEFT JOIN
-- =====================================================
-- This query retrieves ALL persons regardless of whether
-- they have an address or not
-- =====================================================

SELECT
    p.firstName,    -- First name from Person table
    p.lastName,     -- Last name from Person table
    a.city,         -- City from Address table (NULL if no address)
    a.state         -- State from Address table (NULL if no address)
FROM
    Person AS p     -- Left table (all rows will be included)
LEFT JOIN
    Address AS a    -- Right table (only matching rows included)
ON
    p.personId = a.personId;  -- Join condition: match by personId

-- =====================================================
-- EXPECTED RESULT:
-- =====================================================
-- firstName | lastName | city          | state      |
-- ----------|----------|---------------|------------|
-- Wang      | Allen    | NULL          | NULL       |
-- Alice     | Bob      | New York City | New York   |
-- John      | Doe      | Los Angeles   | California |
-- Jane      | Smith    | NULL          | NULL       |
-- Michael   | Johnson  | Chicago       | Illinois   |
-- =====================================================

-- =====================================================
-- COMPARISON: INNER JOIN (for reference)
-- =====================================================
-- This would only return persons WITH addresses
-- Excludes Wang Allen and Jane Smith
-- =====================================================

-- SELECT
--     p.firstName,
--     p.lastName,
--     a.city,
--     a.state
-- FROM
--     Person AS p
-- INNER JOIN
--     Address AS a
-- ON
--     p.personId = a.personId;

-- =====================================================
-- ADDITIONAL USEFUL QUERIES
-- =====================================================

-- Query 1: Find persons WITHOUT addresses
-- SELECT
--     p.firstName,
--     p.lastName
-- FROM
--     Person AS p
-- LEFT JOIN
--     Address AS a ON p.personId = a.personId
-- WHERE
--     a.personId IS NULL;

-- Query 2: Count persons by address status
-- SELECT
--     CASE 
--         WHEN a.personId IS NULL THEN 'No Address'
--         ELSE 'Has Address'
--     END AS AddressStatus,
--     COUNT(*) AS PersonCount
-- FROM
--     Person AS p
-- LEFT JOIN
--     Address AS a ON p.personId = a.personId
-- GROUP BY
--     AddressStatus;

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- LEFT JOIN: Returns all rows from the LEFT table (Person)
--            and matching rows from RIGHT table (Address)
-- 
-- NULL values: When no match exists in Address table,
--              city and state will be NULL
--
-- Use Cases:
--   - Report all persons including those without addresses
--   - Find persons missing address information
--   - Generate mailing lists with incomplete data
-- =====================================================