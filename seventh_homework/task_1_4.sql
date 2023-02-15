/*********************** Домашнее задание №1.4 *******************************/
--Экспериментальным путем выбрать оптимальные* 
--индексы для следующих полей у таблиц в схеме
--bookings:
--tickets.contact_data = '{"phone": "+70001171617"}'


-- БЕЗ ИНДЕКСА. Время - 1.5 s. Память - 0 mB.
SELECT * FROM bookings.tickets AS t WHERE t.contact_data = '{"phone": "+70001171617"}'


-- B-Tree. Время 22 - ms. Память - 226 mB.
CREATE INDEX idx_4_b_tree ON bookings.tickets (contact_data);
EXPLAIN
SELECT * FROM bookings.tickets AS t WHERE t.contact_data = '{"phone": "+70001171617"}';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_4_b_tree'));
DROP INDEX bookings.idx_4_b_tree;


-- HASH. Время - 21 ms. Память - 80 mB.
CREATE INDEX idx_4_hash ON bookings.tickets USING HASH (contact_data);
SELECT * FROM bookings.tickets AS t WHERE t.contact_data = '{"phone": "+70001171617"}';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_4_hash'));
DROP INDEX bookings.idx_4_hash;


-- GiST. Время - 22 ms. Память - 174 mB.
CREATE INDEX idx_4_gist ON bookings.tickets USING GiST (((contact_data->>'phone')::TEXT));
SELECT * FROM bookings.tickets AS t WHERE t.contact_data->>'phone' = '+70001171617';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_4_gist'));
DROP INDEX bookings.idx_4_gist;


-- GIN. Время - 21 s. Память - 204 mB.
CREATE INDEX idx_4_gin ON bookings.tickets USING GIN (((contact_data->>'phone')::TEXT));
EXPLAIN
SELECT * FROM bookings.tickets AS t WHERE t.contact_data->>'phone' = '+70001171617';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_4_gin'));
DROP INDEX bookings.idx_4_gin;



-- BRIN. Время - 926 ms. Память - 64 kB.
CREATE INDEX idx_4_brin ON bookings.tickets USING BRIN (((contact_data->>'phone')::TEXT));
SELECT * FROM bookings.tickets AS t WHERE t.contact_data->>'phone' = '+70001171617';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_4_brin'));
DROP INDEX bookings.idx_4_brin;


/*********** Результаты *************/

--B-Tree....22....21mB
--HASH......21....114mB - Лучший по скорости
--GIST......22....178mB
--GIN.......21....17mB
--BRIN......826...64kB - Лучший по памяти


