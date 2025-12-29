# Danny’s Diner — SQL Case Study (PostgreSQL)

This project contains my solutions to the **Danny’s Diner SQL Case Study**, a 10-question business analytics challenge solved using **PostgreSQL**.  
The focus of this project is writing **clear, correct, and readable SQL** to answer real-world customer and sales questions.

This project demonstrates how SQL is used in a **data analyst workflow**: joining tables, applying business rules, and using window functions to extract insights.

---

## Skills Demonstrated
- SQL joins across multiple tables
- Aggregations (`SUM`, `COUNT`, `COUNT(DISTINCT)`)
- Common Table Expressions (CTEs)
- Window functions (`RANK() OVER (...)`)
- Conditional logic using `CASE`
- Date-based business rules
- Writing readable, well-commented SQL for review

---

## Dataset Overview
The case study uses three tables:

- **sales**  
  Customer orders including product and order date  

- **menu**  
  Product details and prices  

- **members**  
  Loyalty program membership start dates  

These tables simulate a small restaurant loyalty system.

---

## Questions Answered
The SQL file answers the following business questions:

1. Total amount spent by each customer  
2. Number of days each customer visited  
3. First item(s) purchased by each customer  
4. Most purchased item overall and purchase count  
5. Most popular item for each customer  
6. First item purchased after becoming a member  
7. Item purchased just before becoming a member  
8. Total items and total spend before membership  
9. Loyalty points per customer (10 points per $1, sushi earns 2× points)  
10. Loyalty points for customers A & B through end of January with first-week 2× bonus  

Some questions intentionally return multiple rows per customer when ties occur (e.g., multiple purchases on the same day).

---

## Project Structure

```text
dannys-diner-sql/
├── case_study.sql -- Solutions to all 10 SQL questions
└── setup.sql -- (Optional) Schema and data setup
```

---

## How to Run (Optional)
This project is intended to be **read directly on GitHub** — running the code is not required.

If you want to execute the queries locally:

1. Load the tables into a PostgreSQL database  
2. Set the schema:
   ```sql
   SET search_path = dannys_diner;
