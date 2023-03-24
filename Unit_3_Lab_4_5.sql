#unit 3 lab 4

use sakila;

# question 1 How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT COUNT(*) AS num_copies
FROM Inventory
JOIN Film ON Inventory.film_id = Film.film_id
WHERE Film.title = 'Hunchback Impossible';

# question 2 List all films whose length is longer than the average of all the films.

SELECT title, length
FROM Film
WHERE length > (SELECT AVG(length) FROM Film);

# quetion 3 Use subqueries to display all actors who appear in the film Alone Trip.


SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
  SELECT film_actor.actor_id
  FROM film_actor
  INNER JOIN film ON film_actor.film_id = film.film_id
  WHERE film.title = 'Alone Trip'
);

# Question 4 Sales have been lagging among young families, and you wish to target all family movies 
# for a promotion. Identify all movies categorized as family films.

SELECT f.title
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

# Question 5 
# Get name and email from customers from Canada using subqueries. 


SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
  SELECT address_id
  FROM address
  WHERE city_id IN (
    SELECT city_id
    FROM city
    WHERE country_id = (
      SELECT country_id
      FROM country
      WHERE country = 'Canada'
    )
  )
);

# Do the same with joins.
# Note that to create a join, you will have to identify the correct tables with their primary keys 
# and foreign keys, that will help you get the relevant information.

SELECT c.first_name, c.last_name, c.email
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ct ON a.city_id = ct.city_id
INNER JOIN country cn ON ct.country_id = cn.country_id
WHERE cn.country = 'Canada';

# Question 6 
# Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films.
# First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

SELECT a.actor_id, a.first_name, a.last_name, COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;

SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
  SELECT a.actor_id
  FROM actor a
  JOIN film_actor fa ON a.actor_id = fa.actor_id
  GROUP BY a.actor_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

# Question 7
# Films rented by most profitable customer. 
# You can use the customer table and payment table to find the most profitable customer ie the customer
# that has made the largest sum of payments

SELECT c.customer_id, c.first_name, c.last_name, MAX(p.amount) as max_amount
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY max_amount DESC
LIMIT 1;

SELECT f.title
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE p.amount = (SELECT MAX(amount) FROM payment);

# Question 8
# Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount 
# spent by each client.

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_amount_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE (
  SELECT AVG(total_amount_spent)
  FROM (
    SELECT customer_id, SUM(amount) AS total_amount_spent
    FROM payment
    GROUP BY customer_id
  ) AS t
) < (
  SELECT SUM(p2.amount)
  FROM payment p2
  WHERE p2.customer_id = c.customer_id
)
GROUP BY c.customer_id, c.first_name, c.last_name;

# UNIT 3 LAB 5
#For each film, list actor that has acted in more films.

WITH film_actor_counts AS (
  SELECT 
    film_id,
    actor_id,
    COUNT(*) AS num_films
  FROM 
    film_actor
  GROUP BY 
    film_id,
    actor_id
),
film_max_actor_counts AS (
  SELECT film_id,
    MAX(num_films) AS max_films
  FROM 
    film_actor_counts
  GROUP BY 
    film_id
)
SELECT 
  f.title,
  a.first_name,
  a.last_name
FROM 
  film f
  JOIN film_actor_counts fac ON f.film_id = fac.film_id
  JOIN actor a ON fac.actor_id = a.actor_id
  JOIN film_max_actor_counts fmac ON fac.film_id = fmac.film_id AND fac.num_films = fmac.max_films
ORDER BY 
  f.title;





