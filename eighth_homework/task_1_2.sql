/* ******************************** Задание №1.2 *********************************** */

--Запрос считает общее количество мест в самолете и количество проданных билетов на рейсы

-- Время без модификаций - 30s
SELECT  
	f.scheduled_departure::date as vilet,
    f.flight_no,
	a1.airport_name AS from_air,
	a2.airport_name AS to_air,
	(SELECT COUNT(*) FROM bookings.seats AS s WHERE s.aircraft_code = f.aircraft_code) AS vsego_mest,
	(SELECT COUNT(*) FROM bookings.ticket_flights AS tf WHERE tf.flight_id = f.flight_id) AS zanyato_mest
FROM bookings.flights AS f
JOIN bookings.airports AS a1 
	ON a1.airport_code = f.departure_airport
JOIN bookings.airports as a2 
	ON a2.airport_code = f.arrival_airport
ORDER BY vilet
LIMIT 100;



-- Создадим индекс по ticket_flights.flight_id и вынесем общее число мест в каждом
-- самолёте в отдельный CTE.
-- Время с модификациями - 450ms

CREATE INDEX idx_ticket_flight_id ON bookings.ticket_flights (flight_id);

WITH total_seats AS 
	(
	SELECT 
		aircraft_code,
		COUNT(*) AS seats_number
	FROM bookings.seats AS s
	GROUP BY aircraft_code
	)
SELECT  
	f.scheduled_departure::date as vilet,
    f.flight_no,
	a1.airport_name AS from_air,
	a2.airport_name AS to_air,
	total_seats.seats_number AS vsego_mest,
	(SELECT COUNT(*) FROM bookings.ticket_flights AS tf WHERE tf.flight_id = f.flight_id) AS zanyato_mest
FROM bookings.flights AS f
JOIN bookings.airports AS a1 
	ON a1.airport_code = f.departure_airport
JOIN bookings.airports as a2 
	ON a2.airport_code = f.arrival_airport
LEFT JOIN total_seats
	USING (aircraft_code)
ORDER BY vilet
LIMIT 100;

DROP INDEX bookings.idx_ticket_flight_id;
