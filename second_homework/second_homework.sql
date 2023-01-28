/*********************** Домашняя Работа №2 *********************/


-- Создаём временную таблицу для извлечения данных из csv файла
CREATE TABLE tag_data.tempo
	(
	setup_type_name VARCHAR(15) NOT NULL,
	tag_name VARCHAR(30) NOT NULL,
	tag_description VARCHAR(100) NOT NULL,
	param_name VARCHAR(30) NOT NULL,
	measure_name VARCHAR(15) NOT NULL,
	tag_timestamptz TIMESTAMPTZ NOT NULL,
	tag_value REAL NOT NULL
	);


-- Извлекаем данные в таблицу-посредник
COPY tag_data.tempo
	(
	setup_type_name,
	tag_name,
	tag_description,
	param_name,
	measure_name,
	tag_timestamptz,
	tag_value
	) 
FROM 'C://DataImportExport//tag_data.csv' WITH (FORMAT CSV, DELIMITER ';', ENCODING 'UTF8', HEADER);


-- Заполняем таблицы с установками, параметрами и единицами измерения
INSERT INTO tag_data.setup_types (setup_type_name)
SELECT DISTINCT setup_type_name FROM tag_data.tempo;
SELECT * FROM tag_data.setup_types; --все 4 уникальных значения присутствуют.

INSERT INTO tag_data.params (param_name)
SELECT DISTINCT param_name FROM tag_data.tempo;
SELECT * FROM tag_data.params; --все 5 уникальных значения присутствуют.

INSERT INTO tag_data.measures (measure_name)
SELECT DISTINCT measure_name FROM tag_data.tempo;
SELECT * FROM tag_data.measures; --все 8 уникальных значения присутствуют.


-- Заполним таблицу с тэгами
INSERT INTO tag_data.tags 
   (tag_name, 
	tag_description, 
	setup_type_id, 
	param_id,
	measure_id)
SELECT DISTINCT
	tempo.tag_name,
	tempo.tag_description,
	setup.setup_type_id,
	param.param_id,
	measure.measure_id
FROM
	tag_data.tempo AS tempo,
	tag_data.setup_types AS setup,
	tag_data.params AS param,
	tag_data.measures AS measure
WHERE
	tempo.setup_type_name = setup.setup_type_name
	AND tempo.param_name = param.param_name
	AND tempo.measure_name = measure.measure_name;
SELECT * FROM tag_data.tags; --все 17 уникальных значения присутствуют.


-- Заполним таблицу со значениями по тэгам
INSERT INTO tag_data.reports 
   (tag_id, 
	tag_timestamptz, 
	tag_value)
SELECT
	tag.tag_id,
	tempo.tag_timestamptz,
	tempo.tag_value
FROM
	tag_data.tags AS tag,
	tag_data.tempo AS tempo
WHERE
	tempo.tag_name = tag.tag_name;
SELECT * FROM tag_data.reports;


-- Временная таблица tempo больше не понадобится
TRUNCATE TABLE tag_data.tempo;
DROP TABLE tag_data.tempo;


-- Запрос на извелечение данных в исходном виде 
SELECT
	setup.setup_type_name AS "Установка",
	tag.tag_name AS "Имя тега",
	tag.tag_description AS "Описание тега",
	param.param_name AS "Измеряемый параметр",
	measure.measure_name AS "Ед. Изм.",
	report.tag_timestamptz AS "Дата/Время значения тега",
	report.tag_value AS "Значение тега"
FROM
	tag_data.setup_types AS setup,
	tag_data.tags AS tag,
	tag_data.params AS param,
	tag_data.measures AS measure,
	tag_data.reports AS report
WHERE 
	setup.setup_type_id = tag.setup_type_id
	AND tag.tag_id = report.tag_id
	AND param.param_id = tag.param_id
	AND measure.measure_id = tag.measure_id
