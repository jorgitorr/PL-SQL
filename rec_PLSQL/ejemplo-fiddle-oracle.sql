
create type t_lines as table of varchar2(4000)
/

create or replace function get_lines
return t_lines pipelined is
  lines dbms_output.chararr;
  numlines integer;
begin
  numlines := 999;
  dbms_output.get_lines(lines, numlines);
  if numlines > 0 then
    for i in 1..numlines loop
      pipe row (lines(i));
    end loop;
  else
    pipe row ('No data');
  end if;
end;
/

create table Employee(name varchar2(100),id integer, salary integer,PRIMARY KEY(id))
/
insert into Employee(name,id,salary) values('pepe',94,100)
/
insert into Employee(name,id,salary) values('juan',88,150)
/
insert into Employee(name,id,salary) values('maria',33,900)
/
insert into Employee(name,id,salary) values('pedro',24,880)
/
insert into Employee(name,id,salary) values('andrea',65,770)
/
insert into Employee(name,id,salary) values('julia',69,910)
/
insert into Employee(name,id,salary) values('mario',12,650)
/
insert into Employee(name,id,salary) values('inma',43,440)
/
insert into Employee(name,id,salary) values('raul',40,550)
/



-----------------Ejemplo de código SQL



select * from Employee where id>90

/



-----------------Ejemplo de código PL/SQL


begin
  dbms_output.enable(20000);
end;
/

declare
  employee_record employee%rowtype;
begin
  select * into employee_record from employee where id>90;
  dbms_output.put_line(employee_record.name||' '||employee_record.id||' '||employee_record.salary);
end;
/

select * from table(get_lines)
/


