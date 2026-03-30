-- =====================================================
-- Rank Scores Query
-- =====================================================
-- Purpose: Rank all scores from highest to lowest without gaps
-- Returns: Each score with its corresponding rank
-- Method: DENSE_RANK() window function
-- Database: MS SQL Server (T-SQL)
-- =====================================================

-- Drop table if it exists (for clean setup)
DROP TABLE IF EXISTS Scores;

-- =====================================================
-- TABLE CREATION
-- =====================================================

CREATE TABLE Scores (
    id INT PRIMARY KEY,
    score DECIMAL(3,2) NOT NULL
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

INSERT INTO Scores (id, score) VALUES
(1, 3.50),     -- Rank 1 (highest)
(2, 3.65),     -- Rank 1 (highest, duplicate)
(3, 4.00),     -- Rank 1 (highest)
(4, 3.85),     -- Rank 2
(5, 4.00),     -- Rank 1 (duplicate)
(6, 3.65);     -- Rank 1 (duplicate)

-- =====================================================
-- MAIN QUERY
-- =====================================================

SELECT
    score,
    DENSE_RANK() OVER(ORDER BY score DESC) AS 'rank'
FROM Scores;

-- =====================================================
-- HOW IT WORKS:
-- =====================================================
-- STEP 1: DENSE_RANK() assigns ranks
--   Orders scores from highest to lowest (DESC)
--   Same scores get same rank
--   No gaps in ranking sequence
--
-- STEP 2: Result
--   score | rank
--   ------|------
--   4.00  | 1  ← Highest
--   4.00  | 1  ← Same rank (duplicate)
--   3.85  | 2  ← Next rank (no gap)
--   3.65  | 3
--   3.65  | 3  ← Same rank (duplicate)
--   3.50  | 4  ← Lowest

-- =====================================================
-- KEY CONCEPTS
-- =====================================================
-- DENSE_RANK(): Window function that assigns sequential ranks
--   - Duplicate values get same rank
--   - No gaps in ranking (1,2,3,4 not 1,1,3,4)
--   - Continues sequentially after duplicates
--
-- OVER(ORDER BY score DESC): Window specification
--   - DESC: Highest score gets rank 1
--   - Applies ranking across entire result set
--
-- AS 'rank': Column alias for output
--   - Single quotes allowed in T-SQL
--   - Makes result more readable

-- =====================================================
-- EXECUTION EXAMPLE
-- =====================================================
-- Given scores: 4.00, 4.00, 3.85, 3.65, 3.65, 3.50
--
-- Step 1: Order by score DESC
--   4.00, 4.00, 3.85, 3.65, 3.65, 3.50
--
-- Step 2: Assign DENSE_RANK
--   4.00 → 1
--   4.00 → 1 (same as previous)
--   3.85 → 2 (next rank, no gap)
--   3.65 → 3
--   3.65 → 3 (same as previous)
--   3.50 → 4 (next rank)

-- =====================================================
-- DENSE_RANK vs RANK vs ROW_NUMBER
-- =====================================================
-- score | DENSE_RANK | RANK | ROW_NUMBER
-- ------|------------|------|------------
-- 4.00  | 1          | 1    | 1
-- 4.00  | 1 ← Same   | 1    | 2 ← Unique
-- 3.85  | 2 ← No gap | 3    | 3 ← Gap
-- 3.65  | 3          | 4    | 4
-- 3.65  | 3          | 4    | 5
-- 3.50  | 4          | 6    | 6
--
-- DENSE_RANK: No gaps, handles duplicates ✅
-- RANK: Has gaps after duplicates (1,1,3,4,4,6)
-- ROW_NUMBER: Every row unique (1,2,3,4,5,6)

-- =====================================================
-- EXPECTED RESULT:
-- =====================================================
-- score | rank
-- ------|------
-- 4.00  | 1
-- 4.00  | 1
-- 3.85  | 2
-- 3.65  | 3
-- 3.65  | 3
-- 3.50  | 4
-- =====================================================

-- =====================================================
-- ORDER BY DIRECTION
-- =====================================================
-- DESC (Descending - Used here):
--   Highest score = Rank 1
--   Example: 4.00 gets rank 1, 3.50 gets rank 4
--
-- ASC (Ascending - Alternative):
--   Lowest score = Rank 1
--   Example: 3.50 gets rank 1, 4.00 gets rank 4

-- =====================================================
-- COMMON MISTAKES
-- =====================================================
-- ❌ Using RANK() instead of DENSE_RANK()
--    Result: 1,1,3,4,4,6 (has gaps)
--
-- ❌ Forgetting DESC
--    Result: Lowest score gets rank 1 instead of highest
--
-- ❌ Using ROW_NUMBER()
--    Result: Duplicates get different ranks (loses tie information)

-- =====================================================
-- USE CASES
-- =====================================================
-- ✅ Leaderboards (sports, games, exams)
-- ✅ Competition rankings with ties
-- ✅ Grade/score ranking systems
-- ✅ Performance evaluations
-- ✅ Any scenario where duplicates should share rank

-- =====================================================
-- RECOMMENDATION
-- =====================================================
-- Use DENSE_RANK() when:
--   ✅ You want consecutive ranking (no gaps)
--   ✅ Duplicate values should have same rank
--   ✅ Need fair ranking system (leaderboards)
--
-- Performance tip:
--   CREATE INDEX idx_score ON Scores(score DESC);
--   - Speeds up ORDER BY operation

-- =====================================================
-- END OF DOCUMENTATION
-- =====================================================