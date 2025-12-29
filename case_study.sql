SET search_path = dannys_diner;

-- 1. What is the total amount each customer spent at the restaurant?
    SELECT
        customer_id, sum(price)
    FROM sales as S
    INNER JOIN menu as M on
        S.product_id = M.product_id
    GROUP BY customer_id;

-- 2. How many days has each customer visited the restaurant?
    SELECT
        customer_id,
        COUNT(DISTINCT order_date) AS visit_days
    FROM sales
    GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
    WITH first_day AS (SELECT *, RANK() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ) AS rnk
    FROM sales AS s
    )

    SELECT f.customer_id, f.order_date, product_name
    FROM first_day AS f
    JOIN menu as m ON
        f.product_id = m.product_id
    WHERE rnk =1
    ORDER BY customer_id, product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
    SELECT
      m.product_name,
      COUNT(*) AS n_purchases
    FROM sales s
    JOIN menu m ON
        s.product_id = m.product_id
    GROUP BY m.product_name
    ORDER BY n_purchases DESC
    LIMIT 1;

-- 5. Which item was the most popular for each customer?
     WITH most_popular AS (SELECT s.customer_id,
                                  m.product_name,
                                  COUNT(*) AS n_purchases,
                                  RANK() OVER (
                                      PARTITION BY customer_id
                                      ORDER BY COUNT(*) DESC
                                      )    AS rnk
                           FROM sales s
                            JOIN menu m ON
                               s.product_id = m.product_id
                           GROUP BY m.product_name, s.customer_id)

    SELECT customer_id, product_name, n_purchases
    FROM most_popular
    WHERE rnk = 1
    ORDER BY customer_id, product_name;

-- 6. Which item was purchased first by the customer after they became a member?
    WITH memb_purchase AS (
            SELECT s.customer_id,
            s.order_date,
            memb.join_date,
            m.product_name,
            RANK() OVER(
                PARTITION BY s.customer_id
                ORDER BY s.order_date
                ) AS rnk
            FROM sales AS s
            INNER JOIN members AS memb ON
                s.order_date >= memb.join_date AND
                s.customer_id = memb.customer_id
            INNER JOIN menu as m ON
            s.product_id = m.product_id
            )

    SELECT *
    FROM memb_purchase
    WHERE rnk = 1;

-- 7. Which item was purchased just before the customer became a member?
    WITH memb_purchase AS (
            SELECT s.customer_id,
            s.order_date,
            memb.join_date,
            m.product_name,
            RANK() OVER(
                PARTITION BY s.customer_id
                ORDER BY s.order_date DESC
                ) AS rnk
            FROM sales AS s
            INNER JOIN members AS memb ON
                s.order_date < memb.join_date AND
                s.customer_id = memb.customer_id
            INNER JOIN menu as m ON
            s.product_id = m.product_id
            )
    SELECT *
    FROM memb_purchase
    WHERE rnk = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
    WITH memb_purchase AS (
            SELECT
                s.customer_id,
                s.product_id,
                COUNT(*) AS cnt
            FROM sales AS s
            JOIN members AS memb ON
                s.order_date < memb.join_date AND
                s.customer_id = memb.customer_id
            GROUP BY s.customer_id, s.product_id

            )

    SELECT
        memb_p.customer_id,
        SUM(memb_p.cnt * m.price) AS spent,
        SUM(memb_p.cnt) AS n_items
    FROM memb_purchase as memb_p
    JOIN menu AS m ON
        memb_p.product_id = m.product_id
    GROUP BY memb_p.customer_id
    ORDER BY customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
    SELECT
        s.customer_id,
        SUM(
            CASE
            WHEN m.product_name = 'sushi' THEN m.price * 20
            ELSE m.price * 10
        END
            ) AS total_points
    FROM sales AS s
    JOIN menu AS m ON
        s.product_id = m.product_id
    GROUP BY s.customer_id
    ORDER BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
    SELECT
      s.customer_id,
      SUM(
        CASE
          -- first 7 days after joining inclusive: 2x on everything
          WHEN s.order_date BETWEEN memb.join_date
               AND memb.join_date + INTERVAL '6 days'
            THEN m.price * 20

          -- after first week: sushi still earns 2x
          WHEN m.product_name = 'sushi'
            THEN m.price * 20

          -- normal points
          ELSE m.price * 10
        END
      ) AS total_points
    FROM sales AS s
    JOIN members AS memb
      ON s.customer_id = memb.customer_id
    JOIN menu AS m
      ON s.product_id = m.product_id
    WHERE s.order_date <= '2021-01-31'
    GROUP BY s.customer_id
    ORDER BY s.customer_id;