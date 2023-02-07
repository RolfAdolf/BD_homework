/*********************** Домашнее задание №5.4 *******************************/
--Написать функцию, принимающую на вход массив 
--Numeric и считающую с помощью цикла среднее 
--арифметическое всех его элементов.


CREATE OR REPLACE FUNCTION public.f_get_average_from_array(input_array NUMERIC[])
RETURNS NUMERIC AS 
$$
	DECLARE 
		elements_sum NUMERIC;
		elements_count INTEGER;
		cur_array_element NUMERIC;
	BEGIN
		elements_sum := 0;
		elements_count := 0;
		FOREACH cur_array_element IN ARRAY input_array
		LOOP
			elements_sum := elements_sum + cur_array_element;
			elements_count := elements_count + 1;
		END LOOP;
		
		RETURN elements_sum / elements_count;
		
	END;
	
$$
LANGUAGE PLPGSQL;

SELECT public.f_get_average_from_array(ARRAY[1.5, 2.25, 3.78]);