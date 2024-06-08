create or replace trigger control_number_scuderie
before insert or update on Scuderia
for each row

declare 

scuderia_count	number(2,0);

begin

select count(*) into scuderia_count
from Scuderia;

if scuderia_count > 10 then
	raise_application_error(-20014,'Le scuderie possono essere massimo 10');
end if;

end;