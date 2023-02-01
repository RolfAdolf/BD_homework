/*********************** Домашнее задание №3.1 *******************************/
CREATE VIEW public.v_flights AS
SELECT
	flights.flight_no AS "Номер рейса",
	flights.scheduled_departure AS "дата и время вылета",
	flights.departure_airport AS "код аэропорта вылета",
	departure_airport.city AS "город вылета",
	departure_airport.airport_name AS "аэропорт вылета",
	flights.scheduled_arrival AS "дата и время прилета",
	flights.arrival_airport AS "код аэропорта прилета",
	arrival_airport.city AS "город прилета",
	arrival_airport.airport_name AS "аэропорт прилета",
	aircraft.model AS "модель самолета"
FROM bookings.flights AS flights
INNER JOIN bookings.airports_data AS departure_airport
	ON flights.departure_airport = departure_airport.airport_code
INNER JOIN bookings.airports_data AS arrival_airport
	ON flights.arrival_airport = arrival_airport.airport_code
INNER JOIN bookings.aircrafts_data AS aircraft
	ON flights.aircraft_code = aircraft.aircraft_code
WHERE
	((departure_airport.city::json->>'ru' = 'Санкт-Петербург') OR (departure_airport.city::json->>'ru'  = 'Москва'))
	AND (flights.scheduled_departure::time < time '12:00:00');
	

--SELECT * FROM public.v_flights;


