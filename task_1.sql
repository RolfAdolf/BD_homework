/*********************** Домашнее задание №4.1 *******************************/
-- №4.1.a
SELECT 
	aircrafts.model AS "Тип самолёта",
	TO_CHAR(flights.scheduled_departure, 'YYYY-MM-DD') AS "Дата рейса",
	COUNT(flights.flight_id) AS "Число рейсов"
FROM bookings.flights AS flights
JOIN bookings.aircrafts_data AS aircrafts
	USING(aircraft_code)
WHERE TO_CHAR(flights.scheduled_departure, 'YYYY-MM') = '2017-01'
GROUP BY "Тип самолёта", "Дата рейса";


-- №4.1.b
SELECT
	TO_CHAR(book_date, 'YYYY-MM-DD') AS "Дата",
	SUM(books.total_amount) AS "Сумма бронирований",
	AVG(books.total_amount) AS "Средняя стоимость бронирований"
FROM bookings.bookings AS books
WHERE TO_CHAR(book_date, 'YYYY-MM') = '2017-01'
GROUP BY "Дата";