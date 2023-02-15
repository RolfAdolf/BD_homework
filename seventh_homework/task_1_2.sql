/*********************** Домашнее задание №1.2 *******************************/
--Экспериментальным путем выбрать оптимальные* 
--индексы для следующих полей у таблиц в схеме
--bookings:
--tickets.passenger_id = '9999 985697'


-- БЕЗ ИНДЕКСА. Время - 643 ms. Память - 0 mB.
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697'


-- B-Tree. Время 22 - ms. Память - 89 mB.
CREATE INDEX idx_2_b_tree ON bookings.tickets (passenger_id);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_2_b_tree'));
DROP INDEX bookings.idx_2_b_tree;


-- HASH. Время - 22 ms. Память - 80 mB.
CREATE INDEX idx_2_hash ON bookings.tickets USING HASH (passenger_id);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_2_hash'));
DROP INDEX bookings.idx_2_hash;


-- GiST. Время - 23 ms. Память - 136 mB.
CREATE INDEX idx_2_gist ON bookings.tickets USING GiST (passenger_id);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_2_gist'));
DROP INDEX bookings.idx_2_gist;


-- GIN. Время - 22 ms. Память - 204 mB.
CREATE INDEX idx_2_gin ON bookings.tickets USING GIN (passenger_id);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_2_gin'));
DROP INDEX bookings.idx_2_gin;


-- BRIN. Время - 32 ms. Память - 56 kB.
CREATE INDEX idx_2_brin ON bookings.tickets USING BRIN (passenger_id);
SELECT * FROM bookings.tickets AS t WHERE t.passenger_id = '9999 985697';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_2_brin'));
DROP INDEX bookings.idx_2_brin;


/*********** Результаты *************/

--B-Tree....22....89mB
--HASH......22....80mB - Лучший вариант по скорости
--GIST......23....136mB
--GIN.......22....204mB
--BRIN......32....56kB - Лучший по памяти

