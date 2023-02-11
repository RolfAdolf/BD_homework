/*********************** Домашнее задание №6.1 *******************************/

-- Создать таблицу prodmag.products_log со структурой, как 
-- prodmag.products плюс поле add_date (время внесения изменений) 
-- плюс поле operation (insert/delete/update), плюс поле 
-- row(new/old). Написать триггер на вставку, обновление и 
-- удаление записей в таблице prodmag.products. Триггер должен 
-- логгировать изменения в таблицу prodmag.products_log.

CREATE OR REPLACE FUNCTION prodmag.trg() RETURNS TRIGGER AS
$$
BEGIN
	
	IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE'
	THEN
	
		INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id, qty, price, cost, seller_id, deadline, add_date, operation, _row)
		VALUES( 
			OLD.product_id,
			OLD.products_name,
			OLD.food_type_id,
			OLD.unit_id,
			OLD.qty,
			OLD.price,
			OLD.cost,
			OLD.seller_id,
			OLD.deadline,
			LOCALTIMESTAMP(2),
			TG_OP,
			'old');
		
	END IF;
	
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE'
	THEN
	
		INSERT INTO prodmag.products_log(product_id, products_name, food_type_id, unit_id, qty, price, cost, seller_id, deadline, add_date, operation, _row)
		VALUES( 
			NEW.product_id,
			NEW.products_name,
			NEW.food_type_id,
			NEW.unit_id,
			NEW.qty,
			NEW.price,
			NEW.cost,
			NEW.seller_id,
			NEW.deadline,
			LOCALTIMESTAMP(2),
			TG_OP,
			'new');
		
	END IF;
		
	RETURN NULL;

END;
$$
LANGUAGE PLPGSQL;


CREATE TABLE prodmag.products_log
	(
	product_id INT NOT NULL,
	products_name VARCHAR(24) NOT NULL,
	food_type_id SMALLINT NOT NULL,
	unit_id SMALLINT NOT NULL,
	qty INTEGER NOT NULL DEFAULT 0,
	price NUMERIC(6,2) NOT NULL,
	cost NUMERIC(10,2) NOT NULL,
	deadline SMALLINT NOT NULL,
	seller_id INTEGER NOT NULL,
	add_date TIMESTAMP NOT NULL,
	operation VARCHAR(6) NOT NULL,
	_row VARCHAR(3) NOT NULL
	);
	

CREATE TRIGGER tr_after_row
AFTER INSERT OR UPDATE OR DELETE
ON prodmag.products
FOR EACH ROW
EXECUTE FUNCTION prodmag.trg();


INSERT INTO prodmag.products (products_name, food_type_id, unit_id, qty, price, seller_id, deadline)
VALUES ('Помело', 10, 1, 56, 52.2, 1, 20);

UPDATE prodmag.products SET price = price * 0.90 WHERE products_name = 'Помело';

DELETE FROM prodmag.products WHERE products_name = 'Помело';

SELECT * FROM prodmag.products_log;
