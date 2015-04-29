set serveroutput on
--exemplul 1
<<outerBlock>>

DECLARE
  v_outer VARCHAR2(50):= 'dog';
BEGIN
  DECLARE
    v_inner VARCHAR2 (50) := 'cat';
    v_outer VARCHAR2 (50) := 'mouse';
  BEGIN
  dbms_output.put_line ('Value 1:'|| v_inner);
   dbms_output.put_line ('Value 2:'|| v_outer);
    dbms_output.put_line ('Value 3:'|| outerBlock.v_outer);
  EXCEPTION
    WHEN OTHERS
    THEN
         NULL;
  END;
   dbms_output.put_line ('Value 4:'|| v_outer);
EXCEPTION 
when others then
null;
end;

--exemplul 2

DECLARE 
employee_rec employees%ROWTYPE;
BEGIN
SELECT *
INTO employee_rec
FROM employees
WHERE employee_id =&a;
dbms_output.put_line ('ID: '|| employee_rec.employee_id);
dbms_output.put_line ('First Name: '|| employee_rec.first_name);
END;

--exemplul 3

DECLARE 
v_procent NUMBER := 0.1;
v_prag employees.salary%type :=&a;
BEGIN
UPDATE employees
  SET salary = salary+salary*v_procent
  WHERE salary < v_prag;
  
END;

SELECT * 
FROM employees
WHERE salary < 10000 AND employee_id = 198;

--exemplul 4
DECLARE
  TYPE rec_location IS RECORD
  (
  adresa locations.city%type,
  cod_postal locations.postal_code%type
  );
  v_location rec_location;
  BEGIN
  
  SELECT city, postal_code
  INTO v_location.adresa, v_location.cod_postal
  FROM locations
  WHERE location_id=&p_id;
  dbms_output.put_line('Adresa: ' || v_location.adresa || CHR(10)|| 'cod postal'|| v_location.cod_postal);
  EXCEPTION
  when no_data_found
  then dbms_output.put_line('Nu exista locatia!');
  end;
  
--exemplul 5

DECLARE
jobid employees.job_id%type;
empid employees.employee_id%type := 115;
sal_raise NUMBER(3,2);
BEGIN
  SELECT job_id 
  INTO jobid
  FROM employees
  WHERE employee_id = empid;
   
    IF jobid = 'PU_CLERK' THEN sal_raise := .09;
    ELSIF jobid = 'SH_CLERK' THEN sal_raise := .08;
    ELSIF jobid = 'ST_CLERK' THEN sal_raise := .07;
    ELSe sal_raise :=0;
    END IF;
    
    dbms_output.put_line(sal_raise);
    
  END;
    
--exemplul 6
DECLARE
 grade CHAR(1);
 BEGIN
  grade := 'B';
    CASE grade
      WHEN 'A' THEN
      dbms_output.put_line('Excellent');
      WHEN 'B' THEN 
      dbms_output.put_line('Very Good');
       WHEN 'C' THEN 
      dbms_output.put_line('Good');
       WHEN 'D' THEN 
      dbms_output.put_line('Fair');
       ELSE dbms_output.put_line('no such grade');
    END CASE;
  END;

--iterative structures      
-- exemplul 7 simple loop
DECLARE 
i NUMBER := 0;
BEGIN
  LOOP
    i:= i+1;
    dbms_output.put_line (TO_CHAR(i));
    EXIT WHEN i=4;
  END LOOP;
END;
 
 
--exemplul 8 for

BEGIN
  FOR i IN REVERSE 1..3 
    LOOP
      dbms_output.put_line (i);
    END LOOP;
END;

--exemplul 9 while

DECLARE
 i NUMBER := 1;
 BEGIN
  WHILE i<=3
     LOOP
       dbms_output.put_line (i);
       i := i+1;
     END LOOP;
 END;

-- exemplul 10 cursor
DECLARE
  CURSOR departments_curs IS 
    SELECT dp.department_id, dp.department_name, dp.location_id
    FROM departments dp;
  departments_rec departments_curs%ROWTYPE;
  BEGIN
    IF 
      departments_curs%ISOPEN = FALSE THEN--cursorul nu a fost deschis
      OPEN departments_curs;
    END IF;
    
      LOOP 
         FETCH departments_curs INTO departments_rec;
         EXIT WHEN departments_curs%NOTFOUND;
         dbms_output.put_line(departments_rec.department_id||''||departments_rec.department_name);
      END LOOP;
      close departments_curs;
    END;

-- error 
--exemplul 11

DECLARE 
v_name VARCHAR2(5);
  BEGIN 
    BEGIN
      v_name := 'Justice';
      dbms_output.put_line (v_name);
    EXCEPTION
     WHEN value_error
     THEN
      dbms_output.put_line('Error in inner block');
    END;
  EXCEPTION
       WHEN value_error
     THEN
      dbms_output.put_line('Error in inner block');
    END;
    
--exemplul 12
DECLARE 
invalid_loc EXCEPTIOn;
BEGIN 
UPDATE LOCATIONS LOC
SET LOC.POSTAL_CODE = '678012'
WHERE LOC.city LIKE '&A';
IF SQL%NOTFOUND
THEN
RAISE invalid_loc;
END IF;
EXCEPTION
  WHEN invalid_loc
  THEN 
  raise_application_error(-20100,'Nu exista');
END;

-- EXERCITIIIIII!!!

--1

DECLARE
--de preferat o singura var.. in if ii dam valoare + un singur update
v_procent1 NUMBER := 1.20;
v_procent2 NUMBER := 1.10;
v_procent3 NUMBER := 1.05;

v_experienta NUMBER;

BEGIN
SELECT floor((trunc(sysdate) - trunc(hire_date)
)/365)
INTO v_experienta
FROM employees
WHERE employee_id = 115;

IF v_experienta  BETWEEN 5 AND 10 THEN 
UPDATE employees
SET salary = salary*v_procent2
WHERE employee_id = 115;

ELSIF v_experienta > 10
THEN 
UPDATE employees
SET salary = salary*v_procent1
WHERE employee_id = 115;

ELSE 
UPDATE employees
SET salary = salary *v_procent3
WHERE employee_id = 115;
END IF;

END;

--2

DECLARE
an NUMBER ;
nr_angajari NUMBER;
nr NUMBER;

BEGIN
SELECT extract (year from hire_date)as anul,count(*) as anjajari 
INTO an,nr_angajari
FROM employees
GROUP BY extract (year from hire_date)
HAVING COUNT(*)=( SELECT MAX(COUNT(*)) FROM employees e
                GROUP BY TO_CHAR(HIRE_DATE,'YYYY'));

FOR i in 1..12 
LOOP 
SELECT COUNT(*) 
 into nr
  FROM employees
  WHERE TO_CHAR(HIRE_DATE,'MM')= i AND to_char(hire_date,'yyyy')=an;
  
dbms_output.put_line('luna:'||i||' '||'nr angajati:'||nr||'anul'||an);
END LOOP;

END;



SELECT extract year from 
(hire_date)as anul--,count(*) as anjajari 
--INTO an,nr_angajari
FROM employees