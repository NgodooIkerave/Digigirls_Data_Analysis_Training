
-- CyberSafe Foundation DigiGirls Data Analysis Program
-- SQL Capstone Project
-- Advanced SQL Questions
-- Database: dvdrental


-- QUESTION 1
-- Display the customer names that share the same address 
-- (e.g. husband and wife).

SELECT 
    c.first_name, 
    c.last_name,
    a.address_id, 
    a.address
FROM 
    customer AS c, 
    address AS a
WHERE 
    a.address = a.address;


-- QUESTION 2
-- What is the name of the customer who made the highest 
-- total payments?

SELECT 
    c.first_name, 
    c.last_name,
    SUM (py.amount) AS highest_total_payment
FROM 
    customer AS c 
INNER JOIN payment AS py
    ON c.customer_id = py.customer_id
GROUP BY 
    c.customer_id
ORDER BY 
    highest_total_payment DESC
LIMIT 1;


-- QUESTION 3
-- What is the movie(s) that was rented the most?

SELECT 
    m.title AS movie_title,
    COUNT (r.rental_id) AS total_number_of_times_rented
FROM 
    film AS m 
INNER JOIN inventory i 
    ON m.film_id = i.film_id
INNER JOIN rental r 
    ON i.inventory_id = r.inventory_id
GROUP BY 
    film_id
ORDER BY 
    total_number_of_times_rented DESC
LIMIT 10;


-- QUESTION 4
-- Which movies have been rented so far?

SELECT 
    DISTINCT m.title AS movie_title
FROM 
    film AS m 
INNER JOIN inventory i 
    ON m.film_id = i.film_id
INNER JOIN rental AS r 
    ON i.inventory_id = r.inventory_id;


-- QUESTION 5
-- Which movies have not been rented so far?

SELECT 
    DISTINCT m.title AS movie_title
FROM 
    film AS m 
LEFT JOIN inventory i 
    ON m.film_id = i.film_id
LEFT JOIN rental AS r 
    ON i.inventory_id = r.inventory_id
WHERE 
    r.rental_id IS NULL;


-- QUESTION 6
-- Which customers have not rented any movies so far?

SELECT
    DISTINCT c.customer_id, 
             c.first_name, 
             c.last_name
FROM 
    customer AS c 
INNER JOIN rental AS r 
    ON c.customer_id = r.customer_id
WHERE 
    r.rental_id IS NULL;


-- QUESTION 7
-- Display each movie and the number of times it got rented.

SELECT
    m.title AS movie_title,
    COUNT (r.rental_id) AS number_of_times_rented 
FROM 
    film AS m 
INNER JOIN inventory AS i 
    ON m.film_id = i.film_id
INNER JOIN rental AS r 
    ON r.inventory_id = i.inventory_id
GROUP BY 
    m.film_id
ORDER BY 
    number_of_times_rented DESC;


-- QUESTION 8
-- Show the first name and last name 
-- and the number of films each actor acted in.

SELECT
    a.actor_id,
    CONCAT (a.first_name,'',a.last_name) AS fullname,
    COUNT(fa.film_id) AS number_of_films_acted
FROM 
    actor AS a 
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id
ORDER BY 
    number_of_films_acted DESC;


-- QUESTION 9
-- Display the names of the actors that acted 
-- in more than 20 movies.

SELECT
    a.actor_id,
    CONCAT (a.first_name,'',a.last_name) AS fullname,
    COUNT (fa.film_id) AS number_of_films_acted
FROM 
    actor AS a 
INNER JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
GROUP BY 
    a.actor_id
HAVING 
    COUNT (fa.film_id) > 20
ORDER BY 
    number_of_films_acted DESC;


-- QUESTION 10
-- For all the movies rated “PG” show me 
-- the movie and the number of times it got rented.

SELECT
    DISTINCT m.film_id,
             m.title AS movie_title,
             m.rating AS movie_rating,
    COUNT (r.rental_id) AS number_of_times_rented 
FROM 
    film AS m 
INNER JOIN inventory AS i 
    ON m.film_id = i.film_id
INNER JOIN rental AS r 
    ON r.inventory_id = i.inventory_id
WHERE 
    m.rating = 'PG'
GROUP BY 
    m.film_id
ORDER BY 
    number_of_times_rented DESC;


-- QUESTION 11
-- Display the movies offered for rent 
-- in store_id 1 and not offered in store_id 2.

SELECT
    DISTINCT m.film_id,
             m.title AS movie_title
FROM 
    film AS m 
WHERE 
    m.film_id IN (
    SELECT i.film_id
    FROM inventory AS i 
WHERE 
    i.store_id = 1
AND m.film_id NOT IN (
    SELECT i.film_id
    FROM inventory AS i 
WHERE i
.store_id = 2
));


-- QUESTION 12
-- Display the movies offered for rent in any of the two 
-- stores 1 and 2.

SELECT
    DISTINCT m.film_id,
             m.title AS movie_title
FROM 
    film AS m 
WHERE 
    m.film_id IN (
    SELECT i.film_id
    FROM 
        inventory AS i 
WHERE 
    i.store_id = 1
OR m.film_id IN (
    SELECT i.film_id
    FROM inventory AS i 
WHERE 
    i.store_id = 2
));


-- QUESTION 13
-- Display the movie titles of those movies offered 
-- in both stores at the same time.

SELECT
    DISTINCT m.film_id,
         m.title AS movie_title
FROM 
    film AS m 
WHERE m.film_id IN (
    SELECT i.film_id
    FROM inventory AS i 
WHERE 
    i.store_id = 1
AND m.film_id IN (
    SELECT i.film_id
    FROM inventory AS i 
WHERE 
    i.store_id = 2
));


-- QUESTION 14
-- Display the movie title for the most rented movie 
-- in the store with store_id 1.

SELECT
    m.film_id,
    m.title AS movie_title,
    i.store_id,
    COUNT (DISTINCT(r.rental_id)) AS most_rented_movie 
FROM 
    film AS m 
INNER JOIN inventory AS i 
    ON m.film_id = i.film_id
INNER JOIN rental AS r 
    ON r.inventory_id = i.inventory_id
WHERE 
    i.store_id = 1
GROUP BY 
    m.film_id, i.store_id
ORDER BY 
    most_rented_movie DESC
LIMIT 1;


-- QUESTION 15
-- How many movies are not offered for rent in the stores 
-- yet. There are two stores only 1 and 2.

SELECT
    COUNT (*) AS movies_not_offered_for_rent_yet
FROM 
    film AS m 
LEFT JOIN inventory AS i 
    ON m.film_id = i.film_id
LEFT JOIN rental AS r 
    ON r.inventory_id = i.inventory_id
WHERE 
    i.store_id IS NULL
OR 
    i.store_id NOT IN (1,2);


-- QUESTION 16
-- Show the number of rented movies under each rating.

SELECT
    m.rating AS movie_rating,
    COUNT(DISTINCT(r.rental_id)) AS number_of_rented_movies 
FROM 
    film AS m 
INNER JOIN inventory AS i 
    ON m.film_id = i.film_id
INNER JOIN rental AS r 
    ON r.inventory_id = i.inventory_id
WHERE 
    m.rating IS NOT NULL
GROUP BY 
    m.rating
ORDER BY 
    number_of_rented_movies  DESC;


-- QUESTION 17
-- Show the profit of each of the stores 1 and 2.

SELECT 
    store_id,
    SUM(amount) AS profit
FROM 
    payment AS py
INNER JOIN rental AS r
    ON py.rental_id = r.rental_id
INNER JOIN inventory AS i 
    ON r.inventory_id = i.inventory_id
GROUP BY 
    i.store_id
ORDER BY 
    profit DESC;
