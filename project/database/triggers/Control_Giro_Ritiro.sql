create or replace trigger control_giro_ritiro
before insert or update on Si_ritira
for each row

declare

max_giri	Gara.num_giri_effettuati%type;

begin

select num_giri_effettuati into max_giri
from Gara where data_gara = :NEW.data_gara;

if :NEW.num_giro > max_giri then
	raise_application_error(-20003,'Il giro di ritiro inserito supera il massimo numero di giri della gara!');
end if;

end;




