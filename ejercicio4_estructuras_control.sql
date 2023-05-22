
create or replace procedure Desglose(num1 NUMBER)
as 
    num2 NUMBER:=num1;
	multiplicacion NUMBER;
begin 
	loop
    EXIT WHEN num2=0;  
    	if num2>=5000 then 
    		dbms_output.put_line('Te tiene que devolver en 5000 ='||TRUNC
(num2/5000));
    		multiplicacion:=TRUNC
(num2/5000);
		num2:=mod(num2,5000*multiplicacion);
		elsif num2>=2000 then 
    		dbms_output.put_line('Te tiene que devolver en 2000 ='||TRUNC
(num2/2000));
    		multiplicacion:=TRUNC
(num2/2000);
			num2:=mod(num2,2000*multiplicacion);
		elsif num2>=1000 then 
    		dbms_output.put_line('Te tiene que devolver en 1000 ='||TRUNC
(num2/1000));
    		multiplicacion:=TRUNC
(num2/1000);
			num2:=mod(num2,1000*multiplicacion);
		elsif num2>=500 then 
    		dbms_output.put_line('Te tiene que devolver en 500 ='||TRUNC
(num2/500));
    		multiplicacion:=TRUNC
(num2/500);
			num2:=mod(num2,500*multiplicacion);
		elsif num2>=200 then 
    		dbms_output.put_line('Te tiene que devolver en 200 ='||TRUNC
(num2/200));
    		multiplicacion:=TRUNC
(num2/200);
			num2:=mod(num2,200*multiplicacion);
		elsif num2>=100 then 
    		dbms_output.put_line('Te tiene que devolver en 100 ='||TRUNC
(num2/100));
    		multiplicacion:=TRUNC
(num2/100);
			num2:=mod(num2,100*multiplicacion);
		elsif num2>=50 then 
    		dbms_output.put_line('Te tiene que devolver en 50 ='||TRUNC
(num2/50));
    		multiplicacion:=TRUNC
(num2/50);
			num2:=mod(num2,50*multiplicacion);
		elsif num2>=25 then 
    		dbms_output.put_line('Te tiene que devolver en 25 ='||TRUNC
(num2/25));
    		multiplicacion:=TRUNC
(num2/25);
			num2:=mod(num2,25*multiplicacion);
		elsif num2>=10 then 
    		dbms_output.put_line('Te tiene que devolver en 10 ='||TRUNC
(num2/10));
    		multiplicacion:=TRUNC
(num2/10);
			num2:=mod(num2,10*multiplicacion);
		elsif num2>=5 then 
    		dbms_output.put_line('Te tiene que devolver en 5 ='||TRUNC
(num2/5));
    		multiplicacion:=TRUNC
(num2/5);
			num2:=mod(num2,5*multiplicacion);
		elsif num2>=1 then 
    		dbms_output.put_line('Te tiene que devolver en 1 ='||TRUNC
(num2/1));
    		multiplicacion:=TRUNC
(num2/1);
			num2:=mod(num2,1*multiplicacion);
		else 
            dbms_output.put_line('La cuenta esta a cero');
    	end if;
    end loop;
end;
