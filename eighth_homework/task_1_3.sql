/* ******************************** Задание №1.3 *********************************** */

--Запрос показывает рассадку пассажиров в бизнес-классе в Аэробасе Боинг 737-300

-- Время без модификаций - 8.2s
SELECT 
    f.flight_no,
    f.scheduled_departure,
    a.model,
    t.passenger_name,
    bp.ticket_no,
    bp.seat_no
FROM bookings.flights AS f
JOIN bookings.aircrafts AS a ON a.aircraft_code = f.aircraft_code
JOIN bookings.ticket_flights AS tf ON tf.flight_id = f.flight_id
JOIN bookings.boarding_passes AS bp ON bp.flight_id = tf.flight_id AND bp.ticket_no = tf.ticket_no
JOIN bookings.tickets AS t ON t.ticket_no = tf.ticket_no
WHERE a.model = 'Боинг 737-300'
	AND tf.fare_conditions = 'Business'
ORDER BY f.scheduled_departure DESC, bp.seat_no ASC
LIMIT 100;


-- модификации
-- Сначала выделим 100 нужных значений, а уже потом будем объединять
-- Время с модификацией - 1.765s
WITH flights_model AS 
	(
	SELECT
		f.flight_id,
		f.flight_no,
		f.scheduled_departure,
		f.departure_airport,
		f.arrival_airport,
		f.aircraft_code
	FROM bookings.flights AS f
	WHERE aircraft_code = (SELECT aircraft_code FROM bookings.aircrafts AS a WHERE a.model = 'Боинг 737-300')
	),
flights AS
	(
	SELECT f.*, tf.ticket_no, seat_no
	FROM flights_model AS f
	JOIN bookings.ticket_flights AS tf
		USING (flight_id)
	JOIN bookings.boarding_passes AS bp
		ON bp.flight_id = f.flight_id AND bp.ticket_no = tf.ticket_no
	
	WHERE tf.fare_conditions = 'Business'
	ORDER BY f.scheduled_departure DESC, bp.seat_no ASC
	LIMIT 100
	)
SELECT 
    f.flight_no,
    f.scheduled_departure,
    'Боинг 737-300' AS model,
    t.passenger_name,
    f.ticket_no,
    f.seat_no
FROM flights AS f
JOIN bookings.tickets AS t USING (ticket_no);


