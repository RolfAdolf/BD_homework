/*********************** Домашнее задание №3.2 *******************************/
CREATE VIEW public.v_tag_data AS
SELECT
	tags.tag_name AS "Имя тэга",
	measures.measure_name AS "Единица измерения",
	reports.tag_timestamptz AS "Дата и время значения",
	reports.tag_value AS "Значение тега"
FROM tag_data.tags AS tags
JOIN tag_data.measures AS measures
	USING(measure_id)
JOIN
	(
	SELECT * FROM (SELECT reps.tag_value, reps.tag_id, reps.tag_timestamptz FROM tag_data.reports AS reps WHERE tag_id = 1 ORDER BY tag_timestamptz DESC LIMIT 10) AS reports_1
	UNION
	SELECT * FROM (SELECT reps.tag_value, reps.tag_id, reps.tag_timestamptz FROM tag_data.reports AS reps WHERE tag_id = 2 ORDER BY tag_timestamptz DESC LIMIT 10) AS reports_2
	UNION
	SELECT * FROM (SELECT reps.tag_value, reps.tag_id, reps.tag_timestamptz FROM tag_data.reports AS reps WHERE tag_id = 3 ORDER BY tag_timestamptz DESC LIMIT 10) AS reports_3
	) AS reports
	USING(tag_id);


--SELECT * FROM public.v_tag_data;