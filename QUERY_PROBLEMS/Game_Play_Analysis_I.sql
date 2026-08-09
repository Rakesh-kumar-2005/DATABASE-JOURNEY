-- =====================================================
-- Game Play Analysis I - First Login and Device
-- =====================================================
-- Purpose: Find first login date and device for each player
-- Returns: player_id, device_id, and first event_date
-- Problem: LeetCode - Game Play Analysis I
-- Database: SQL (Generic)
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Activity;

-- =====================================================
-- TABLE CREATION
-- =====================================================

CREATE TABLE Activity (
    player_id INT,
    device_id INT,
    event_date DATE,
    games_played INT,
    PRIMARY KEY (player_id, event_date)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Activity (player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

-- =====================================================
-- SOLUTION 1: WINDOW FUNCTION (ROW_NUMBER)
-- =====================================================

SELECT 
    player_id,
    device_id,
    event_date
FROM (
    SELECT 
        player_id,
        device_id,
        event_date,
        ROW_NUMBER() OVER (
            PARTITION BY player_id 
            ORDER BY event_date
        ) AS row_num
    FROM Activity
) t
WHERE row_num = 1;

-- =====================================================
-- HOW SOLUTION 1 WORKS:
-- =====================================================
-- STEP 1: ROW_NUMBER() assigns rank per player
--   PARTITION BY player_id: Separate numbering for each player
--   ORDER BY event_date: Earliest date gets row_num = 1
--
-- Inner Query Result:
--   player_id | device_id | event_date  | row_num
--   -----------|-----------|-----------  |--------
--   1          | 2         | 2016-03-01 | 1 ← First
--   1          | 2         | 2016-05-02 | 2
--   2          | 3         | 2017-06-25 | 1 ← First
--   3          | 1         | 2016-03-02 | 1 ← First
--   3          | 4         | 2018-07-03 | 2
--
-- STEP 2: WHERE row_num = 1 filters first login
--   player_id | device_id | event_date  | row_num
--   -----------|-----------|-----------  |--------
--   1          | 2         | 2016-03-01 | 1 ✅
--   2          | 3         | 2017-06-25 | 1 ✅
--   3          | 1         | 2016-03-02 | 1 ✅
--
-- STEP 3: Final output
--   player_id | device_id | event_date
--   -----------|-----------|-----------
--   1          | 2         | 2016-03-01
--   2          | 3         | 2017-06-25
--   3          | 1         | 2016-03-02

-- =====================================================
-- KEY CONCEPTS (Solution 1):
-- =====================================================
-- ROW_NUMBER(): Assigns sequential rank per partition
-- PARTITION BY player_id: Separate ranking for each player
-- ORDER BY event_date: Earliest date = rank 1
-- Subquery: Required to filter window function results
-- WHERE row_num = 1: Keeps first login per player

-- =====================================================
-- =====================================================
-- =====================================================

-- =====================================================
-- SOLUTION 2: GROUP BY with MIN (RECOMMENDED)
-- =====================================================

SELECT 
    a.player_id,
    a.device_id,
    a.event_date
FROM Activity a
INNER JOIN (
    SELECT 
        player_id,
        MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
) first_login
ON a.player_id = first_login.player_id
AND a.event_date = first_login.first_date;

-- =====================================================
-- HOW SOLUTION 2 WORKS:
-- =====================================================
-- STEP 1: Subquery finds minimum event_date per player
--   player_id | first_date
--   -----------|-----------
--   1          | 2016-03-01
--   2          | 2017-06-25
--   3          | 2016-03-02
--
-- STEP 2: INNER JOIN matches players with first date
--   Joins Activity with first_login on:
--   - a.player_id = first_login.player_id
--   - a.event_date = first_login.first_date
--
-- STEP 3: Final Output
--   player_id | device_id | event_date
--   -----------|-----------|-----------
--   1          | 2         | 2016-03-01
--   2          | 3         | 2017-06-25
--   3          | 1         | 2016-03-02

-- =====================================================
-- KEY CONCEPTS (Solution 2):
-- =====================================================
-- Subquery: Finds minimum event_date per player
-- GROUP BY: Groups by player_id
-- INNER JOIN: Matches original data with first dates
-- Two conditions: Both player_id and event_date must match

-- =====================================================
-- SOLUTION 3: CROSS APPLY / LATERAL (Alternative)
-- =====================================================

-- SELECT 
--     a.player_id,
--     a.device_id,
--     a.event_date
-- FROM Activity a
-- WHERE (a.player_id, a.event_date) IN (
--     SELECT player_id, MIN(event_date)
--     FROM Activity
--     GROUP BY player_id
-- );

-- =====================================================
-- COMPARISON: SOLUTION 1 vs SOLUTION 2
-- =====================================================

-- Feature           | Solution 1 (Window) | Solution 2 (JOIN)
-- ------------------|---------------------|------------------
-- Readability       | ⚠️ Needs subquery   | ⚠️ Complex JOIN
-- Code Lines        | Medium              | Medium
-- Performance       | ✅ Efficient        | ✅ Efficient
-- Complexity        | Simple logic        | Two-step process
-- device_id Include | ✅ Direct           | ✅ Direct
-- Best Practice     | ✅ For ranking      | ✅ For joins
-- Flexibility       | ✅ Easy to extend   | ✅ Easy to modify

-- =====================================================
-- EXPECTED RESULT (BOTH SOLUTIONS):
-- =====================================================
-- player_id | device_id | event_date
-- -----------|-----------|-----------
-- 1          | 2         | 2016-03-01
-- 2          | 3         | 2017-06-25
-- 3          | 1         | 2016-03-02
-- =====================================================

-- =====================================================
-- EXECUTION BREAKDOWN
-- =====================================================

-- Given Data:
-- Player 1: device 2 on 2016-03-01 (first), device 2 on 2016-05-02
-- Player 2: device 3 on 2017-06-25 (first and only)
-- Player 3: device 1 on 2016-03-02 (first), device 4 on 2018-07-03

-- Solution 1:
--   Assigns row_num to each player's logins
--   Player 1: row 1 (2016-03-01, device 2), row 2 (2016-05-02, device 2)
--   Player 2: row 1 (2017-06-25, device 3)
--   Player 3: row 1 (2016-03-02, device 1), row 2 (2018-07-03, device 4)
--   Returns only row_num = 1 for each player

-- Solution 2:
--   Finds first_date: 2016-03-01 (P1), 2017-06-25 (P2), 2016-03-02 (P3)
--   Joins back to find device_id matching these dates
--   Returns player_id, device_id, event_date for first logins

-- =====================================================
-- IMPORTANT: DEVICE_ID WITH DUPLICATE DATES
-- =====================================================

-- If player has same event_date with different devices (rare):
-- player_id | device_id | event_date
-- -----------|-----------|-----------
-- 1          | 2         | 2016-03-01
-- 1          | 5         | 2016-03-01  ← Same date, different device

-- Solution 1: Returns first device encountered (one row)
-- Solution 2: Returns BOTH rows (device 2 and 5)

-- To handle this, use ROW_NUMBER() to pick one:
-- SELECT 
--     player_id,
--     device_id,
--     event_date
-- FROM (
--     SELECT 
--         player_id,
--         device_id,
--         event_date,
--         ROW_NUMBER() OVER (
--             PARTITION BY player_id 
--             ORDER BY event_date, device_id
--         ) AS row_num
--     FROM Activity
-- ) t
-- WHERE row_num = 1;

-- =====================================================
-- EDGE CASES
-- =====================================================

-- Case 1: Player with single login
--   player_id = 4, device_id = 1, event_date = 2016-05-01
--   Result: Returns this as first login ✅

-- Case 2: Player with multiple games on same device
--   Same player_id, device_id, different event_dates
--   Result: Returns earliest event_date ✅

-- Case 3: Player with same date, different devices
--   Rare edge case (handled differently by each solution)
--   Solution 1: Returns one device
--   Solution 2: Returns all devices

-- Case 4: Player with no logins
--   Not in table, not in results ✅

-- =====================================================
-- COMMON MISTAKES
-- =====================================================

-- ❌ Forgetting WHERE row_num = 1
--   Result: Returns all logins (not first only)
--
-- ❌ Using device_id in GROUP BY
--   GROUP BY player_id, device_id
--   Result: Wrong grouping, multiple rows per player
--
-- ❌ Using MAX(event_date) instead of MIN
--   Result: Returns LAST login instead of first
--
-- ❌ Not including device_id in subquery
--   Result: device_id unavailable for SELECT
--
-- ❌ Using LEFT JOIN with MIN
--   Result: Can return multiple rows if duplicate dates

-- =====================================================
-- RECOMMENDATION
-- =====================================================

-- Use SOLUTION 1 (Window Function) because:
--   ✅ Clearest logic (rank = 1 is first)
--   ✅ Handles edge cases naturally
--   ✅ No JOIN needed
--   ✅ Efficient execution
--   ✅ Easy to understand and maintain
--   ✅ Standard approach for "first event" problems
--   ✅ Automatically handles duplicate dates
--
-- Avoid Solution 2 because:
--   ❌ More complex with JOIN
--   ❌ Can return multiple rows if date duplicates
--   ❌ Less intuitive logic

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================