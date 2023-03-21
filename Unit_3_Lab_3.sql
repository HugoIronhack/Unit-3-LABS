## Unit 3 lab 3

use sakila;

# 1 Get all pairs of actors that worked together.

SELECT DISTINCT fa1.actor_id, fa2.actor_id, fa1.film_id # I use distinct to get all unique pairs
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id # check all couple for each film
WHERE fa1.actor_id < fa2.actor_id; # making sure ID's are different

# 2 Get all pairs of customers that have rented the same film more than 3 times.

SELECT DISTINCT i.film_id, r1.customer_id as customer_1, r2.customer_id as customer_2, COUNT(r1.rental_id) as count_common_rent
FROM rental as r1
JOIN rental as r2
ON r1.inventory_id = r2.inventory_id
JOIN inventory as i   
ON r2.inventory_id = i.inventory_id AND r1.customer_id != r2.customer_id
GROUP BY i.film_id, r1.customer_id, r2.customer_id
HAVING count_common_rent > 3; 
# There's no pair of customers that have rented the same film more than 3 time.
# I need to go down to 1> instead of >3 to get 2 pairs of customer who rented the same film

# 3 Get all possible pairs of actors and films.

SELECT a.first_name, a.last_name, f.title
FROM actor as a
CROSS JOIN film as f;













