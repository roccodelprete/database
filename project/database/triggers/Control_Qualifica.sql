create or replace trigger control_qualifica
before insert or update on Qualifica
for each row

begin

if to_date(:NEW.ora_inizio_qualifica, 'HH24:MI') < to_date(:NEW.ora_prevista_qualifica, 'HH24:MI') then
	raise_application_error(-20011,'L''ora di inizio delle qualifiche deve essere uguale o successiva all''ora prevista!');
end if;

if to_date(:NEW.ora_fine_qualifica, 'HH24:MI') < to_date(:NEW.ora_inizio_qualifica, 'HH24:MI') then
	raise_application_error(-20012,'L''ora di fine delle qualifiche deve essere uguale o successiva all''ora di inizio!');
end if;

if :NEW.data_qualifica >= :NEW.data_gara then
	raise_application_error(-20013,'La data delle qualifiche deve essere antecedente alla data della gara!');
end if;

end;