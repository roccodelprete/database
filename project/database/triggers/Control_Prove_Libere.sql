create or replace trigger control_prove_libere
before insert or update on Prove_Libere
for each row

begin

if to_date(:NEW.ora_inizio_prove, 'HH24:MI') < to_date(:NEW.ora_prevista_prove, 'HH24:MI') then
	raise_application_error(-20008,'L''ora di inizio delle prove libere deve essere uguale o successiva all''ora prevista!');
end if;

if to_date(:NEW.ora_fine_prove, 'HH24:MI') < to_date(:NEW.ora_inizio_prove, 'HH24:MI') then
	raise_application_error(-20009,'L''ora di fine delle prove libere deve essere uguale o successiva all''ora di inizio!');
end if;

if :NEW.data_prove >= :NEW.data_gara then
	raise_application_error(-20010,'La data delle prove libere deve essere antecedente alla data della gara!');
end if;

end;