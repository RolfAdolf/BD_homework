/*********************** Домашнее задание №5.2 *******************************/
--Написать функцию, принимающую на вход номер месяца и 
--город вылета и возвращающих списком (не таблицей) 
--номера рейсов. Используйте данные в схеме booking. 
CREATE OR REPLACE FUNCTION public.f_return_flights(IN month_number NUMERIC, IN _city VARCHAR(30))
RETURNS SETOF char(6) AS
$$
	--SELECT DISTINCT flights.flight_no
	SELECT flights.flight_no
	FROM bookings.flights AS flights
	JOIN bookings.airports_data AS airports
		ON flights.departure_airport = airports.airport_code 
	WHERE (airports.city::json->>'ru' = _city) AND (EXTRACT(MONTH FROM flights.scheduled_departure) = month_number)
$$
LANGUAGE SQL;

SELECT public.f_return_flights(9, 'Санкт-Петербург');