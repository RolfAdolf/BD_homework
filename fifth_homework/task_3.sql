/*********************** Домашнее задание №5.3 *******************************/
--Написать процедуру, которая будет записывать новые данные 
--в таблицу «prodmag.products». Данные будем записывать в 
--формате JSON.

CREATE TYPE public.ct_products AS
	(
	product_id INTEGER,
	products_name VARCHAR(24),
	food_type_id SMALLINT,
	unit_id SMALLINT,
	qty INTEGER,
	price NUMERIC(6,2),
	seller_id INTEGER,
	deadline SMALLINT
	);
	
CREATE OR REPLACE PROCEDURE public.p_insert_products_json(input_values JSON) AS
$$
BEGIN
	
	INSERT INTO prodmag.products (product_id, products_name, food_type_id, unit_id, qty,  price, seller_id, deadline)
	SELECT *
	FROM JSON_POPULATE_RECORDSET(NULL::public.ct_products, input_values) AS t;
	
END;
$$
LANGUAGE PLPGSQL;


CALL public.p_insert_products_json('[{"product_id":37,"products_name":"Папайя","food_type_id":10,"unit_id":1,"qty":56,"price":52.2,"seller_id":1,"deadline":20}]');
SELECT * FROM prodmag.products;