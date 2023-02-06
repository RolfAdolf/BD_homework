/*********************** Домашнее задание №4.2 *******************************/
-- 4.2.a
WITH RECURSIVE subemployees AS
(
	SELECT id, parent_id, 0 AS sub_emps_num 
	FROM public.staff
	WHERE NOT id IN (SELECT parent_id FROM public.staff WHERE parent_id IS NOT NULL)
	
	UNION ALL
	
	SELECT DISTINCT bosses.id, bosses.parent_id, CAST(COUNT(employees.id) OVER w AS INTEGER)
	FROM public.staff AS bosses
	JOIN subemployees AS employees
		ON bosses.id = employees.parent_id
	WINDOW w AS (PARTITION BY employees.parent_id)
)
SELECT 
id AS "Id сотрудника", 
SUM(sub_emps_num) AS "Число прямых подчинённых"
FROM subemployees
GROUP BY id;


-- Задание со звёздочкой
WITH RECURSIVE subemployees AS
(
	--Начальный запрос - сотрудники без подчинённых
	SELECT id, parent_id, 0 AS sub_emps_num 
	FROM public.staff
	WHERE NOT id IN (SELECT parent_id FROM public.staff WHERE parent_id IS NOT NULL)
	
	UNION ALL
	
	SELECT DISTINCT bosses.id, bosses.parent_id, CAST(SUM(employees.sub_emps_num) OVER w + COUNT(employees.id) OVER w AS INTEGER)
	FROM public.staff AS bosses
	JOIN subemployees AS employees
		ON bosses.id = employees.parent_id
	WINDOW w AS (PARTITION BY employees.parent_id)
)
SELECT id AS "Id сотрудника", SUM(sub_emps_num) AS "Число подчинённых" 
FROM subemployees
GROUP BY id;