-- =====================================================
-- Rising Temperature Detection Query
-- =====================================================
-- Purpose: Find dates where temperature is higher than previous day
-- Returns: IDs of records with temperature increase from prior day
-- Methods: Self-join with DATE_ADD and Self-join with DATEDIFF
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Weather;

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- Create Weather table
CREATE TABLE Weather (
    id INT PRIMARY KEY,
    recordDate DATE NOT NULL,
    temperature INT NOT NULL
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Weather (id, recordDate, temperature) VALUES
(1, '2015-01-01', 10),     -- Base temperature
(2, '2015-01-02', 25),     -- ✅ Higher than previous day (10 → 25)
(3, '2015-01-03', 20),     -- ❌ Lower than previous day (25 → 20)
(4, '2015-01-04', 30);     -- ✅ Higher than previous day (20 → 30)

-- =====================================================
-- SOLUTION 1: DATE_ADD (RECOMMENDED)
-- =====================================================
-- Adds 1 day to previous date and matches with current date
-- =====================================================

SELECT 
    w1.id                       -- ID of current day record
FROM
    Weather w1                  -- w1 = current day
JOIN 
    Weather w2                  -- w2 = previous day
ON
    w1.recordDate = DATE_ADD(w2.recordDate, INTERVAL 1 DAY)
WHERE 
    w1.temperature > w2.temperature;

-- =====================================================
-- HOW SOLUTION 1 WORKS:
-- =====================================================
-- STEP 1: Self-Join with DATE_ADD
--   DATE_ADD(w2.recordDate, INTERVAL 1 DAY) adds 1 day to w2's date
--   Matches when w1.recordDate = w2.recordDate + 1 day
--
-- Join Results:
--   w1.id | w1.date    | w1.temp | w2.id | w2.date    | w2.temp
--   ------|------------|---------|-------|------------|--------
--   2     | 2015-01-02 | 25      | 1     | 2015-01-01 | 10
--   3     | 2015-01-03 | 20      | 2     | 2015-01-02 | 25
--   4     | 2015-01-04 | 30      | 3     | 2015-01-03 | 20
--
-- STEP 2: WHERE Temperature Filter
--   w1.temperature > w2.temperature
--
--   ID 2: 25 > 10 ✅ KEEP
--   ID 3: 20 > 25 ❌ REMOVE
--   ID 4: 30 > 20 ✅ KEEP
--
-- STEP 3: Final Output
--   id |
--   ---|
--   2  |
--   4  |

-- =====================================================
-- KEY CONCEPTS (Solution 1):
-- =====================================================
-- DATE_ADD(date, INTERVAL n DAY): Adds n days to a date
-- Self-Join: Compares current day (w1) with previous day (w2)
-- Join Condition: w1.recordDate = w2.recordDate + 1 day
-- Execution: FROM → JOIN (date match) → WHERE (temp filter) → SELECT

-- =====================================================
-- =====================================================
-- =====================================================

-- =====================================================
-- SOLUTION 2: DATEDIFF
-- =====================================================
-- Calculates day difference between two dates
-- =====================================================

SELECT 
    w1.id                       -- ID of current day record
FROM 
    Weather w1                  -- w1 = current day
JOIN
    Weather w2                  -- w2 = previous day
ON
    DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE 
    w1.temperature > w2.temperature;

-- =====================================================
-- HOW SOLUTION 2 WORKS:
-- =====================================================
-- STEP 1: Self-Join with DATEDIFF
--   DATEDIFF(w1.recordDate, w2.recordDate) calculates day difference
--   = 1 means w1 is exactly 1 day after w2
--
-- Join Results (same as Solution 1):
--   w1.id | w1.date    | w1.temp | w2.id | w2.date    | w2.temp | DATEDIFF
--   ------|------------|---------|-------|------------|---------|----------
--   2     | 2015-01-02 | 25      | 1     | 2015-01-01 | 10      | 1 ✅
--   3     | 2015-01-03 | 20      | 2     | 2015-01-02 | 25      | 1 ✅
--   4     | 2015-01-04 | 30      | 3     | 2015-01-03 | 20      | 1 ✅
--
-- STEP 2: WHERE Temperature Filter
--   ID 2: 25 > 10 ✅ KEEP
--   ID 3: 20 > 25 ❌ REMOVE
--   ID 4: 30 > 20 ✅ KEEP
--
-- STEP 3: Final Output
--   id |
--   ---|
--   2  |
--   4  |

-- =====================================================
-- KEY CONCEPTS (Solution 2):
-- =====================================================
-- DATEDIFF(date1, date2): Returns date1 - date2 in days
-- DATEDIFF = 1: date1 is exactly 1 day after date2
-- Self-Join: Compares consecutive days
-- Execution: FROM → JOIN (DATEDIFF = 1) → WHERE (temp filter) → SELECT

-- =====================================================
-- COMPARISON: SOLUTION 1 vs SOLUTION 2
-- =====================================================

-- Feature              | Solution 1 (DATE_ADD)  | Solution 2 (DATEDIFF)
-- ---------------------|------------------------|------------------------
-- Readability          | ✅ Clear intent        | ✅ Clear intent
-- Performance          | ✅ Slightly better     | ⚠️ Function overhead
-- Index Usage          | ✅ Can use index       | ❌ Function on column
-- Clarity              | ✅ Explicit +1 day     | ✅ Explicit difference
-- Standard             | ✅ SQL standard        | ✅ SQL standard
-- Flexibility          | ✅ Easy interval change| ✅ Easy difference change

-- Both are valid and produce identical results
-- DATE_ADD is marginally better for performance (index-friendly)
-- DATEDIFF is more intuitive for comparing date differences

-- =====================================================
-- EXPECTED RESULT (BOTH SOLUTIONS):
-- =====================================================
-- id |
-- ---|
-- 2  |
-- 4  |
-- =====================================================

-- Explanation:
-- ID 2: Jan 2 (25°) > Jan 1 (10°) ✅ Temperature rose  
-- ID 3: Jan 3 (20°) < Jan 2 (25°) ❌ Temperature dropped  
-- ID 4: Jan 4 (30°) > Jan 3 (20°) ✅ Temperature rose  

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================

-- Given Data:
-- id | recordDate  | temperature
-- ---|-------------|------------
-- 1  | 2015-01-01  | 10
-- 2  | 2015-01-02  | 25
-- 3  | 2015-01-03  | 20
-- 4  | 2015-01-04  | 30

-- Solution 1: DATE_ADD
--   Jan 2 vs Jan 1: DATE_ADD('2015-01-01', 1) = '2015-01-02' ✅ AND 25 > 10 ✅
--   Jan 3 vs Jan 2: DATE_ADD('2015-01-02', 1) = '2015-01-03' ✅ AND 20 > 25 ❌
--   Jan 4 vs Jan 3: DATE_ADD('2015-01-03', 1) = '2015-01-04' ✅ AND 30 > 20 ✅

-- Solution 2: DATEDIFF
--   Jan 2 vs Jan 1: DATEDIFF('2015-01-02', '2015-01-01') = 1 ✅ AND 25 > 10 ✅
--   Jan 3 vs Jan 2: DATEDIFF('2015-01-03', '2015-01-02') = 1 ✅ AND 20 > 25 ❌
--   Jan 4 vs Jan 3: DATEDIFF('2015-01-04', '2015-01-03') = 1 ✅ AND 30 > 20 ✅

-- =====================================================
-- DATE FUNCTIONS EXPLAINED
-- =====================================================

-- DATE_ADD(date, INTERVAL n unit):
--   Adds specified interval to date
--   Example: DATE_ADD('2015-01-01', INTERVAL 1 DAY) = '2015-01-02'
--   Units: DAY, MONTH, YEAR, HOUR, MINUTE, etc.

-- DATEDIFF(date1, date2):
--   Returns date1 - date2 in days
--   Example: DATEDIFF('2015-01-03', '2015-01-01') = 2
--   Positive: date1 is after date2
--   Negative: date1 is before date2
--   Zero: Same date

-- =====================================================
-- HANDLING GAPS IN DATA
-- =====================================================

-- If dates are not consecutive (e.g., missing Jan 2):
-- id | recordDate  | temperature
-- ---|-------------|------------
-- 1  | 2015-01-01  | 10
-- 3  | 2015-01-03  | 20    ← No Jan 2 record
-- 4  | 2015-01-04  | 30

-- Result:
--   - Jan 3 won't match (no Jan 2 to compare)
--   - Jan 4 will match with Jan 3
--   - Only consecutive days are compared

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ Using DATEDIFF without = 1 (matches non-consecutive days)
-- ❌ Comparing w1.temperature < w2.temperature (finds drops, not rises)
-- ❌ Forgetting self-join (cannot compare consecutive days)

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- Use SOLUTION 1 (DATE_ADD) because:
--   ✅ Slightly better performance (index-friendly)
--   ✅ Explicit about adding 1 day
--   ✅ More efficient on large datasets
--
-- Use SOLUTION 2 (DATEDIFF) when:
--   ✅ More intuitive for your team
--   ✅ Need to check various day differences
--   ✅ Code readability is priority

-- Both solutions are correct and widely used!

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================