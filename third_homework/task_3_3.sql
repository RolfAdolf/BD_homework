/*********************** Домашнее задание №3.3 *******************************/

-- Создаём таблицы
-- Первая таблица
CREATE TABLE public.programming_languages_1
	(
		"Название языка программирования" VARCHAR(20) NOT NULL ,
		CONSTRAINT language_name_1_ukey UNIQUE("Название языка программирования")
	);
-- Вторая таблица
CREATE TABLE public.programming_languages_2
	(
		"Название языка программирования" VARCHAR(20) NOT NULL,
		CONSTRAINT language_name_2_ukey UNIQUE("Название языка программирования") 
	);
	

-- Вставляем значения
INSERT INTO public.programming_languages_1 ("Название языка программирования") VALUES ('Python'), ('C'), ('C++'), ('Java'), ('C#'), ('Visual Basic'), ('JavaScript'), ('SQL');
INSERT INTO public.programming_languages_2 ("Название языка программирования") VALUES ('Visual Basic'), ('JavaScript'), ('SQL'), ('PHP'), ('Swift'), ('Go'), ('R'), ('MATLAB'), ('Perl');


-- Создадим представления для сочетаний запросов
-- Объединение (UNION)
CREATE VIEW public.v_union_prog_langs AS
SELECT * FROM
	(
	SELECT * FROM public.programming_languages_1
	UNION
	SELECT * FROM public.programming_languages_2
	) AS res;
	
-- Пересечение (INTERSECT). Общее у обоих таблиц.
CREATE VIEW public.v_intersect_prog_langs AS
SELECT * FROM
	(
	SELECT * FROM public.programming_languages_1
	INTERSECT
	SELECT * FROM public.programming_languages_2
	) AS res;

-- Вычитание (EXCEPT). То, чем отличаются таблицы друг от друга. UNION / INTERSECT.
CREATE VIEW public.v_except_prog_langs AS
SELECT * FROM
	(
	SELECT * FROM public.v_union_prog_langs
	EXCEPT
	SELECT * FROM public.v_intersect_prog_langs
	) AS res;
	
	
-- Вывод
-- Общие записи
SELECT * FROM public.v_intersect_prog_langs;
-- Различающиеся записи
SELECT * FROM public.v_except_prog_langs;
