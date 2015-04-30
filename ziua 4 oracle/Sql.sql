--ziua 4 Oracle

--ex 1:
CREATE OR REPLACE function verficareCnp(p_cnp in number)
RETURN number
IS 
v_rez number;
BEGIN
IF length(p_cnp)!=13
THEN v_rez := 0;
ELSIF substr (p_cnp,1,1) NOT IN (1,2) THEN v_rez:=0;
ELSIF substr (p_cnp,4,2)>12 then v_rez:= 0;
else v_rez :=1;
END IF;

return v_rez;
END;

set serveroutput on

DECLARE 
BEGIN
IF verficareCnp(2921210160034)=1 then
dbms_output.put_line('cnp bun');
ELSE
dbms_output.put_line('cnp invalid');
END IF;
END;

--ex 2

CREATE OR REPLACE procedure afisare (p_id NUMBER)
IS
cursor curs(c_id NUMBER) IS SELECT department_name ,AVG(salary) as mediu FROM departments d,employees e
WHERE d.department_id = e.department_id AND d.department_id = c_id
GROUP BY department_name;

curs_rec curs%rowtype;
BEGIN 
IF curs%ISOPEN = false THEN open curs(p_id);
END IF;
LOOP
FETCH curs INTO curs_rec;
EXIT WHEN curs%NOTFOUND;
dbms_output.put_line ('nume departament: '||curs_rec.department_name||'salariu mediu: '||curs_rec.mediu);
END LOOP;
CLOSE curs;
END;


EXECUTE afisare(30);

BEGIN 
afisare(40);
END;
-- exemplu cu for

CREATE OR REPLACE procedure afisare (p_id NUMBER)
IS
BEGIN 
for i in(SELECT department_name ,AVG(salary) as mediu FROM departments d,employees e
WHERE d.department_id = e.department_id AND d.department_id = c_id
GROUP BY department_name)
LOOP
dbms_output.put_line ('nume departament: '||i.department_name||'salariu mediu: '||i.mediu);
END LOOP;
END;
  
  
--package

CREATE OR REPLACE PACKAGE TEST_pkg
IS
  FUNCTION is_cnp(p_cnp IN NUMBER)
    RETURN boolean;
    
    PROCEDURE afisare (p_id NUMBER);
    END test_pkg;
    
  CREATE OR REPLACE package body TEST_pkg  
  IS
  FUNCTION(p_cnp in number)
RETURN boolean
IS 
v_rez boolean;
BEGIN
IF length(p_cnp)!=13
THEN v_rez := false;
ELSIF substr (p_cnp,1,1) NOT IN (1,2) THEN v_rez:=false;
ELSIF substr (p_cnp,4,2)>12 then v_rez:= false;
else v_rez :=true;
END IF;

return v_rez;
END;