/************************** ДОМАШНЯЯ РАБОТА №1 ****************************/

-- схема

CREATE SCHEMA tag_data


--*********************************************
-- В отдельные справочные таблицы выделяем колонки:
-- -"Установка": 					4 	уникальных значения на 902 записи
-- -"Имя тэга" и "Описание тэга": 	17 	уникальных значений на 902 записи
-- -"Измеряемый параметр": 			5 	уникальных значений на 902 записи
-- -"Ед. Изм.": 					8 	уникальных значений на 902 записи
-- Остальные столбцы образуют основную таблицу со значениями по тэгам.


-- таблица для типов установок
-- наибольшая длина наименования установки в таблице - 11
CREATE TABLE tag_data.setup_types
	(
	setup_type_id SMALLSERIAL NOT NULL,
	setup_type_name VARCHAR(15) NOT NULL,
	CONSTRAINT setup_types_ukey UNIQUE(setup_type_name),
	CONSTRAINT setup_types_pkey PRIMARY KEY(setup_type_id)
	);
	

-- таблица с измеряемыми параметрами
-- наибольшая длина наименования параметра в таблице - 15
CREATE TABLE tag_data.params
	(
	param_id SMALLSERIAL NOT NULL,
	param_name VARCHAR(30) NOT NULL,
	CONSTRAINT params_ukey UNIQUE(param_name),
	CONSTRAINT params_pkey PRIMARY KEY(param_id)
	);
	

-- таблица с единицами измерения
-- наибольшая длина наименования единицы измерения в таблице - 7
CREATE TABLE tag_data.measures
	(
	measure_id SMALLSERIAL NOT NULL,
	measure_name VARCHAR(15) NOT NULL,
	CONSTRAINT measures_ukey UNIQUE(measure_name),
	CONSTRAINT measures_pkey PRIMARY KEY(measure_id)
	);


-- таблица с тэгами
-- наибольшая длина наименования тэга в таблице - 21
-- наибольшая длина описания тэга в таблице - 61
CREATE TABLE tag_data.tags
	(
	tag_id SMALLSERIAL NOT NULL,
	tag_name VARCHAR(30) NOT NULL,
	tag_description VARCHAR(100) NOT NULL,
	setup_type_id SMALLSERIAL NOT NULL,
	param_id SMALLSERIAL NOT NULL,
	measure_id SMALLSERIAL NOT NULL,
	CONSTRAINT tags_ukey UNIQUE(tag_name),
	CONSTRAINT tags_pkey PRIMARY KEY(tag_id),
	CONSTRAINT setup_type_id_fk FOREIGN KEY (setup_type_id)
		REFERENCES tag_data.setup_types(setup_type_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT param_id_fk FOREIGN KEY (param_id)
		REFERENCES tag_data.params(param_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	CONSTRAINT measure_id_fk FOREIGN KEY (measure_id)
		REFERENCES tag_data.measures(measure_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	


-- основная таблица со значениями по тэгам.
-- ссылается на все предыдущие.
CREATE TABLE tag_data.reports 
	(
	report_id SERIAL NOT NULL,
	tag_id SMALLINT NOT NULL,
	tag_timestamptz TIMESTAMPTZ NOT NULL,
	tag_value REAL NOT NULL,
	CONSTRAINT report_id_pkey PRIMARY KEY(report_id),
	CONSTRAINT tag_id_fk FOREIGN KEY (tag_id)
		REFERENCES tag_data.tags(tag_id)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
	);
	