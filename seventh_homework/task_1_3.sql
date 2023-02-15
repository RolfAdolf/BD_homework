/*********************** Домашнее задание №1.3 *******************************/
--Экспериментальным путем выбрать оптимальные* 
--индексы для следующих полей у таблиц в схеме
--bookings:
--tickets.passenger_name = 'ALEKSEY NOVIKOV'


-- БЕЗ ИНДЕКСА. Время - 150 ms. Память - 0 mB.
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV'


-- B-Tree. Время 25 - ms. Память - 21 mB.
CREATE INDEX idx_3_b_tree ON bookings.tickets (passenger_name);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_3_b_tree'));
DROP INDEX bookings.idx_3_b_tree;


-- HASH. Время - 26 ms. Память - 114 mB.
CREATE INDEX idx_3_hash ON bookings.tickets USING HASH (passenger_name);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_3_hash'));
DROP INDEX bookings.idx_3_hash;


-- GiST. Время - 26 ms. Память - 178 mB.
CREATE INDEX idx_3_gist ON bookings.tickets USING GiST (passenger_name);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_3_gist'));
DROP INDEX bookings.idx_3_gist;


-- GIN. Время - 25 ms. Память - 17 mB.
CREATE INDEX idx_3_gin ON bookings.tickets USING GIN (passenger_name);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_3_gin'));
DROP INDEX bookings.idx_3_gin;


-- BRIN. Время - 170 ms. Память - 64 kB.
CREATE INDEX idx_3_brin ON bookings.tickets USING BRIN (passenger_name);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_name = 'ALEKSEY NOVIKOV';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_3_brin'));
DROP INDEX bookings.idx_3_brin;


/*********** Результаты *************/

--B-Tree....25....21mB
--HASH......26....114mB - Лучший по скорости
--GIST......26....178mB
--GIN.......25....17mB
--BRIN......170...64kB - Лучший по памяти
