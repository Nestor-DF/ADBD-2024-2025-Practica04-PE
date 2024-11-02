-- Obtenga las ventas totales por categoría de películas ordenadas descendentemente.
SELECT c.name, SUM(p.amount) AS total_sells
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_sells DESC;

-- Obtenga las ventas totales por tienda, donde se refleje la ciudad, el país 
-- (concatenar la ciudad y el país empleando como separador la “,”), y el encargado. Pudiera emplear GROUP BY, ORDER BY
SELECT CONCAT(ci.city, ', ', co.country) AS city_country, 
    s.manager_staff_id, 
    SUM(p.amount) AS total_sells
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id, ci.city, co.country, s.manager_staff_id
ORDER BY total_sells DESC;

-- Obtenga una lista de películas, donde se reflejen el identificador, el título, descripción, categoría, el precio, 
-- la duración de la película, clasificación, nombre y apellidos de los actores (puede realizar una concatenación de ambos).
SELECT f.film_id, 
    f.title, 
    f.description, 
    c.name AS category, 
    f.rental_rate AS price, 
    f.length AS duration, 
    f.rating AS classification, 
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Obtenga la información de los actores, donde se incluya sus nombres y apellidos, las categorías y sus películas. 
-- Los actores deben de estar agrupados y, las categorías y las películas deben estar concatenados por “:”
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor, 
    STRING_AGG(DISTINCT c.name, ':') AS categories, 
    STRING_AGG(DISTINCT f.title, ':') AS films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY a.actor_id;



-- Vista para las ventas totales por categoría de películas ordenadas descendentemente
CREATE VIEW view_total_sales_by_category AS
SELECT c.name AS category_name, SUM(p.amount) AS total_sells
FROM film_category fc
JOIN category c ON fc.category_id = c.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_sells DESC;

-- Vista para las ventas totales por tienda, incluyendo ciudad y país concatenados, y el encargado
CREATE VIEW view_total_sales_by_store AS
SELECT CONCAT(ci.city, ', ', co.country) AS city_country, 
    s.manager_staff_id, 
    SUM(p.amount) AS total_sells
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id, ci.city, co.country, s.manager_staff_id
ORDER BY total_sells DESC;

-- Vista para la lista de películas con detalles específicos
CREATE VIEW view_film_list_with_details AS
SELECT f.film_id, 
    f.title, 
    f.description, 
    c.name AS category, 
    f.rental_rate AS price, 
    f.length AS duration, 
    f.rating AS classification, 
    CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id;

-- Vista para la información de actores, incluyendo categorías y películas concatenadas
CREATE VIEW view_actor_info_with_categories_and_films AS
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor, 
    STRING_AGG(DISTINCT c.name, ':') AS categories, 
    STRING_AGG(DISTINCT f.title, ':') AS films
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY a.actor_id;



ALTER TABLE category
ADD CONSTRAINT chk_name CHECK (LENGTH(TRIM(name)) > 0 AND name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$');

ALTER TABLE language
ADD CONSTRAINT chk_name CHECK (LENGTH(TRIM(name)) > 0 AND name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$');

ALTER TABLE actor
ADD CONSTRAINT chk_first_name CHECK (LENGTH(TRIM(first_name)) > 0 AND first_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$'),
ADD CONSTRAINT chk_last_name CHECK (LENGTH(TRIM(last_name)) > 0 AND last_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$');

ALTER TABLE film
ADD CONSTRAINT chk_length CHECK (length > 0),
ADD CONSTRAINT chk_rating CHECK (rating IN ('G', 'PG', 'PG-13', 'R', 'NC-17')),
ADD CONSTRAINT chk_release_year CHECK (release_year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)),
ADD CONSTRAINT chk_rental_duration CHECK (rental_duration > 0),
ADD CONSTRAINT chk_rental_rate CHECK (rental_rate >= 0),
ADD CONSTRAINT chk_replacement_cost CHECK (replacement_cost >= 0),
ADD CONSTRAINT chk_title CHECK (LENGTH(TRIM(title)) > 0 AND title ~* '^[A-Za-z0-9À-ÖØ-öø-ÿ\s!?:&\-]+$'); -- \'

ALTER TABLE rental
ADD CONSTRAINT chk_rental_date CHECK (rental_date <= CURRENT_TIMESTAMP),
ADD CONSTRAINT chk_return_date CHECK (return_date > rental_date);


ALTER TABLE payment
ADD CONSTRAINT chk_payment_date CHECK (payment_date <= CURRENT_TIMESTAMP);

ALTER TABLE customer
ADD CONSTRAINT chk_create_date CHECK (create_date <= CURRENT_TIMESTAMP),
ADD CONSTRAINT chk_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
ADD CONSTRAINT chk_first_name CHECK (LENGTH(TRIM(first_name)) > 0 AND first_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$'),
ADD CONSTRAINT chk_last_name CHECK (LENGTH(TRIM(last_name)) > 0 AND last_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$');

ALTER TABLE staff
ADD CONSTRAINT chk_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'),
ADD CONSTRAINT chk_first_name CHECK (LENGTH(TRIM(first_name)) > 0 AND first_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$'),
ADD CONSTRAINT chk_last_name CHECK (LENGTH(TRIM(last_name)) > 0 AND last_name ~* '^[A-Za-zÀ-ÖØ-öø-ÿ\s\-]+$'),
ADD CONSTRAINT chk_username_length CHECK (LENGTH(username) >= 3),
ADD CONSTRAINT chk_username_format CHECK (username ~* '^[A-Za-z0-9._-]+$'),
ADD CONSTRAINT chk_password_length CHECK (LENGTH(password) >= 6),
ADD CONSTRAINT chk_password_format CHECK (password ~* '^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+=-]+$');

ALTER TABLE address
ADD CONSTRAINT chk_address CHECK (address ~ '^[0-9A-Za-zÀ-ÖØ-öø-ÿ\s\-()\.\,\/&]*$'),
ADD CONSTRAINT chk_address2 CHECK (address2 ~ '^[0-9A-Za-zÀ-ÖØ-öø-ÿ\s\-()\.\,\/\&]*$'),
ADD CONSTRAINT chk_district CHECK (district ~ '^[0-9A-Za-zÀ-ÖØ-öø-ÿ\s\-()\.\,\/&]*$'),
ADD CONSTRAINT chk_phone_format CHECK (phone ~ '^[0-9]*$'),
ADD CONSTRAINT chk_postal_code_length CHECK (LENGTH(postal_code) <= 5),
ADD CONSTRAINT chk_postal_code_format CHECK (postal_code ~ '^[0-9]*$');

ALTER TABLE city
ADD CONSTRAINT chk_city CHECK (city ~ '^[0-9A-Za-zÀ-ÖØ-öø-ÿ\s\-()\.\,\/&]+$');

ALTER TABLE country
ADD CONSTRAINT chk_country CHECK (country ~ '^[0-9A-Za-zÀ-ÖØ-öø-ÿ\s\-()\.\,\/&]+$');



-- Construya un disparador que guarde en una nueva tabla creada por usted la fecha de cuando se insertó un nuevo registro en la tabla film. 
CREATE TABLE film_insert_log (
    log_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    insertion_date TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION log_film_insertion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO film_insert_log (film_id, insertion_date)
    VALUES (NEW.film_id, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER film_insert_log
AFTER INSERT ON film
FOR EACH ROW
EXECUTE FUNCTION log_film_insertion();


-- Construya un disparador que guarde en una nueva tabla creada por usted la fecha de cuando se eliminó un registro en la tabla film y el identificador del film. 
CREATE TABLE film_delete_log (
    log_id SERIAL PRIMARY KEY,
    film_id INTEGER NOT NULL,
    deletion_date TIMESTAMP NOT NULL
);

CREATE OR REPLACE FUNCTION log_film_deletion()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO film_delete_log (film_id, deletion_date)
    VALUES (OLD.film_id, NOW());
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER film_delete_log_trigger
BEFORE DELETE ON film
FOR EACH ROW
EXECUTE FUNCTION log_film_deletion();
