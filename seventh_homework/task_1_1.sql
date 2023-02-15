/*********************** Домашнее задание №1.1 *******************************/
--Экспериментальным путем выбрать оптимальные* 
--индексы для следующих полей у таблиц в схеме
--bookings:
--bookings.book_date = '15.08.2017 17:56:00+03'


-- БЕЗ ИНДЕКСА. Время - 353 ms. Память - 0 mB.
SELECT * FROM bookings.bookings AS b WHERE b.book_date = '15.08.2017 17:56:00+03';


-- B-Tree. Время 22 - ms. Память - 27 mB.
CREATE INDEX idx_1_b_tree ON bookings.bookings (book_date);
SELECT * FROM bookings.bookings AS b WHERE b.book_date = '15.08.2017 17:56:00+03';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_1_b_tree'));
DROP INDEX bookings.idx_1_b_tree;


-- HASH. Время - 22 ms. Память - 64 mB.
CREATE INDEX idx_1_hash ON bookings.bookings USING HASH (book_date);
SELECT * FROM bookings.bookings AS b WHERE b.book_date = '15.08.2017 17:56:00+03';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_1_hash'));
DROP INDEX bookings.idx_1_hash;


-- GiST. Время - 22 ms. Память - 93 mB.
CREATE INDEX idx_1_gist ON bookings.bookings USING GiST (book_date);
SELECT * FROM bookings.bookings AS b WHERE b.book_date = '15.08.2017 17:56:00+03';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_1_gist'));
DROP INDEX bookings.idx_1_gist;


-- GIN. Время - 22 ms. Память - 43 mB.
CREATE INDEX idx_1_gin ON bookings.bookings USING GIN (book_date);
SELECT * FROM bookings.bookings AS b WHERE b.book_date='15.08.2017 17:56:00+03';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_1_gin'));
DROP INDEX bookings.idx_1_gin;


-- BRIN. Время - 280 ms. Память - 48 kB.
CREATE INDEX idx_1_brin ON bookings.bookings USING BRIN (book_date);
SELECT * FROM bookings.bookings WHERE book_date = '15.08.2017 17:56:00+03';
SELECT pg_size_pretty(pg_total_relation_size('bookings.idx_1_brin'));
DROP INDEX bookings.idx_1_brin;



/*********** Результаты *************/

--B-Tree....22....27mB - Лучший по времени
--HASH......22....64mB
--GIST......22....93mB
--GIN.......22....43mB
--BRIN......280....48kB - Лучший по памяти


