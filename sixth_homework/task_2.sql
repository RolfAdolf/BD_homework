/*********************** Домашнее задание №6.2 *******************************/

--Написать триггер на вставку и обновление записей в таблице 
--prodmag.products. Триггер должен выполнять проверку правильности
--сохраняемых в таблице данных и порождать Exception (тем самым не
--давая внести изменения в таблицу), в том случае, если данные не валидные.


CREATE OR REPLACE FUNCTION prodmag.trg_correct_values() RETURNS TRIGGER AS
$$
BEGIN
	
	IF NEW.food_type_id NOT IN (SELECT food_type_id FROM prodmag.food_types)
	THEN 
		RAISE EXCEPTION 'Неверный id типа продукта: %', NEW.food_type_id
		USING HINT = 'id типа продукта должен содержаться в prodmag.food_types.food_type_id', ERRCODE = 23503;
	END IF;

	RETURN NEW;

END;
$$
LANGUAGE PLPGSQL;


CREATE TRIGGER tr_before_row
BEFORE INSERT OR UPDATE
ON prodmag.products
FOR EACH ROW
EXECUTE FUNCTION prodmag.trg_correct_values();



-- Неверный id типа продукта
INSERT INTO prodmag.products (products_name, food_type_id, unit_id, qty, price, seller_id, deadline)
VALUES ('Помело', 15, 1, 56, 52.2, 1, 20);
-- Правильный id типа продукта
INSERT INTO prodmag.products (products_name, food_type_id, unit_id, qty, price, seller_id, deadline)
VALUES ('Помело', 10, 1, 56, 52.2, 1, 20);

-- Попробуем обновить значение
UPDATE prodmag.products SET food_type_id = 15 WHERE products_name = 'Помело';
UPDATE prodmag.products SET food_type_id = 9 WHERE products_name = 'Помело';
