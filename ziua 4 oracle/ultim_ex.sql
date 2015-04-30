  CREATE OR REPLACE package body TEST_pkg  
  IS
  FUNCTION is_cnp(p_cnp in number)
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

    PROCEDURE afisare (p_id NUMBER)
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
END;
    