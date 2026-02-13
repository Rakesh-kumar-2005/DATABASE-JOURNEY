# DATABASE-QUERIES-MYSQL 🗄️

Welcome to my collection of SQL solutions for LeetCode database problems! This repository contains well-documented queries that solve various database challenges, ranging from basic SELECT statements to complex joins and window functions.

## 📖 About This Repository

This repository is dedicated to solving SQL problems from [LeetCode's Database section](https://leetcode.com/problemset/database/). Each solution is crafted with clarity and efficiency in mind, making it a great resource for:

- 🎓 Learning SQL fundamentals and advanced concepts
- 💼 Preparing for technical interviews
- 🔍 Understanding different approaches to common database problems
- 📚 Building a reference library of SQL patterns

## 📂 Repository Structure

Solutions are organized by **problem number** for easy navigation:

```
📦 DATABASE-QUERIES-MYSQL
├── combine_two_tables.sql
├── nth_highest_salary.sql
├── rank_scores.sql
├── consecutive_numbers.sql
├── employees_earning_more.sql
├── duplicate_emails.sql
├── customers_never_order.sql
├── department_highest_salary.sql
├── top_three_salaries.sql
├── delete_duplicate_emails.sql
├── trips_and_users.sql
└── 📄 README.md
```

Each SQL file includes:
- ✅ Problem description and requirements
- ✅ Table schemas with sample data
- ✅ Multiple solution approaches (when applicable)
- ✅ Detailed comments explaining the logic
- ✅ Expected output examples

## 🚀 How to Use

### Prerequisites

- MySQL 5.7+ or MySQL 8.0+ (some solutions use window functions)
- A SQL client (MySQL Workbench, DBeaver, command line, etc.)
- Basic understanding of SQL syntax

### Running the Queries

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/database-queries-mysql.git
   cd database-queries-mysql
   ```

2. **Set up your database:**
   Each SQL file contains table creation statements and sample data insertion. Simply run the entire file:
   ```bash
   mysql -u username -p database_name < 0175_combine_two_tables.sql
   ```

3. **Execute queries individually:**
   Open any `.sql` file in your SQL client and run the queries step by step to see the results.

4. **Test on LeetCode:**
   Copy the solution query (marked clearly in each file) and paste it into the LeetCode code editor to verify.

### Example Workflow

```sql
-- 1. Create and populate tables (included in each file)
CREATE TABLE Person (
    personId INT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50)
);

-- 2. Insert sample data
INSERT INTO Person VALUES (1, 'Wang', 'Allen');

-- 3. Run the solution query
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;
```

## 💡 SQL Techniques & Patterns

This repository covers a wide range of SQL concepts:

### Basic Operations
- `SELECT`, `WHERE`, `ORDER BY`
- Aggregate functions (`COUNT`, `SUM`, `AVG`, `MAX`, `MIN`)
- `GROUP BY` and `HAVING` clauses

### Joins
- `INNER JOIN` - matching records only
- `LEFT JOIN` - all records from left table
- `RIGHT JOIN` - all records from right table
- Self-joins - comparing rows within the same table

### Advanced Topics
- **Subqueries** - nested SELECT statements
- **Window Functions** - `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `LAG()`, `LEAD()`
- **CTEs (Common Table Expressions)** - `WITH` clause for readability
- **CASE statements** - conditional logic
- **String functions** - `CONCAT()`, `SUBSTRING()`, `TRIM()`
- **Date functions** - `DATE_ADD()`, `DATEDIFF()`, `DATE_FORMAT()`

### Performance Tips
- ✅ Use indexes on columns used in `WHERE` and `JOIN` conditions
- ✅ Avoid `SELECT *` - specify only needed columns
- ✅ Use `EXISTS` instead of `IN` for large datasets
- ✅ Consider window functions over self-joins for ranking problems

## 📝 Solution Format

Each solution file follows this structure:

```sql
-- =====================================================
-- Problem #XXX: Problem Title
-- Difficulty: Easy/Medium/Hard
-- Topics: JOIN, Aggregation, etc.
-- =====================================================

-- Problem Description:
-- [Brief explanation of what the problem asks]

-- Table Schemas:
CREATE TABLE TableName (...);

-- Sample Data:
INSERT INTO TableName VALUES (...);

-- Expected Output:
-- [Example result set]

-- =====================================================
-- SOLUTION
-- =====================================================

SELECT ...
FROM ...
WHERE ...;

-- Explanation:
-- [Step-by-step breakdown of the solution logic]

-- Alternative Approaches (if applicable):
-- [Other ways to solve the same problem]
```

## 🤝 Contributing

Contributions are welcome! If you have:
- ✨ Alternative solutions or optimizations
- 🐛 Bug fixes or corrections
- 📚 Additional problem solutions

Please feel free to:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-solution`)
3. Commit your changes (`git commit -m 'Add solution for problem #XXX'`)
4. Push to the branch (`git push origin feature/new-solution`)
5. Open a Pull Request

## 📚 Resources

- [LeetCode Database Problems](https://leetcode.com/problemset/database/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [SQL Tutorial - W3Schools](https://www.w3schools.com/sql/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Happy Querying! 🎯**

*Last Updated: February 2026*
