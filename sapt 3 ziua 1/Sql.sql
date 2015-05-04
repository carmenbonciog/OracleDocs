-- exemple
SELECT e.employee_id,d.department_id,e.last_name
FROM employees e,departments d
WHERE e.employee_id= d.department_id
AND last_name = 'Torres';

SELECT e.employee_id,d.department_id,e.last_name
FROM employees e JOIN departments d
ON(e.employee_id= d.department_id)
WHERE last_name = 'Torres';

--
SELECT CASE WHEN NULL=NULL THEN'Yup' else 'Nope' end as Result FROM dual;

--
set serveroutput on; 

BEGIN
FOR year_index IN REVERSE 1..12 LOOP
dbms_output.put_line(year_index);
END LOOP;
END;
--



