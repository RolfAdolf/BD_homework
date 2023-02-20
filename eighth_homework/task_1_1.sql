/* ******************************** Задание №1.1 *********************************** */
--Запрос ищет пассажиров кто должен был лететь бизнесом и кому не повезло, 
--их рейсы отменили или задержали более одного раза и сумму брони по ним

-- Время работы без модификаций - 1.2s
SELECT
	sel.passenger_name,
    SUM(sel.total_amount)	
FROM
	(
    SELECT 
      COUNT(*) OVER (PARTITION BY t.passenger_name) AS cnt,
      b.total_amount,
      t.passenger_name
    FROM bookings.tickets AS t
    JOIN  bookings.ticket_flights AS tf
        ON tf.ticket_no = t.ticket_no
    JOIN bookings.flights AS f
        ON f.flight_id = tf.flight_id 
    JOIN bookings.bookings AS b
        ON b.book_ref = t.book_ref
    WHERE f.status IN ('Delayed','Cancelled')
        AND tf.fare_conditions = 'Business'
    ) AS sel
WHERE sel.cnt > 1
GROUP BY sel.passenger_name;



-- Модификация
-- Создадим индекс ticket_flights.fare_conditions, т.к. по нему часто проходит поиск.
-- Выделим для удобства 2 CTE, чтобы на ранних этапах отсекать как можно болььше значений.

-- Время - 100ms
CREATE INDEX idx_ticket_flights_fare_conditions ON bookings.ticket_flights (fare_conditions);
CREATE INDEX index_status ON bookings.flights (status);
CREATE INDEX index_ticket_flights_flights_ids ON bookings.ticket_flights (flight_id);
WITH flights AS 
	(
	SELECT 
		flight_id
	FROM bookings.flights AS f
	WHERE f.status IN ('Delayed','Cancelled')
	),
ticket_flights AS
	(
	SELECT 
		ticket_no
	FROM bookings.ticket_flights AS tf
	WHERE tf.fare_conditions = 'Business' AND tf.flight_id IN (SELECT * FROM flights)
	)
SELECT
	t.passenger_name,
	SUM(b.total_amount) AS sum
FROM bookings.tickets AS t
JOIN ticket_flights AS tf
	USING(ticket_no)
JOIN bookings.bookings AS b
	USING(book_ref)
GROUP BY t.passenger_name
HAVING COUNT(*) > 1;

-- Удаляем индексы, чтобы не мешали сравнивать остальные запросы.
DROP INDEX bookings.idx_ticket_flights_fare_conditions;
DROP INDEX bookings.index_status;
DROP INDEX bookings.index_ticket_flights_flights_ids;

