/*********************** Домашнее задание №5.1 *******************************/
-- Написать два варианта скалярной функции, с 
-- IF и CASE, принимающих на вход номер месяца
-- и возвращающих номер квартала.


-- Вариант с IF 
CREATE OR REPLACE FUNCTION public.f_get_quarter_IF(IN month_number NUMERIC)
RETURNS INTEGER AS 
$$
DECLARE 
	res INTEGER;
BEGIN
	IF month_number BETWEEN 1 AND 3 THEN res:= 1;
	ELSIF month_number BETWEEN 4 AND 6 THEN res:= 2;
	ELSIF month_number BETWEEN 7 AND 9 THEN res:= 3;
	ELSE res:= 4;
	END IF;

	RETURN res;

END;
$$
LANGUAGE PLPGSQL;

SELECT public.f_get_quarter_IF(11);


-- Вариант с CASE
CREATE OR REPLACE FUNCTION public.f_get_quarter_CASE(IN month_number NUMERIC)
RETURNS INTEGER AS 
$$
DECLARE 
	res INTEGER;
BEGIN
	CASE month_number 
    WHEN 1,2,3 THEN res := 1;
    WHEN 4,5,6 THEN res := 2;
	WHEN 7,8,9 THEN res := 3;
	ELSE res := 4;
	END CASE;
    
    RETURN res;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.f_get_quarter_CASE(11);



