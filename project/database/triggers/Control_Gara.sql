create or replace trigger control_gara
before insert or update on Gara
for each row

declare

tipo_sponsor	Sponsor.discriminatore_sponsor%type;

begin

if :NEW.num_giri_effettuati > :NEW.num_giri_previsti then
	raise_application_error(-20004,'Il numero di giri effettuati deve essere minore o uguale al numero di giri previsti!');
end if;

if to_date(:NEW.ora_inizio_gara, 'HH24:MI') < to_date(:NEW.ora_prevista_gara, 'HH24:MI') then
	raise_application_error(-20005,'L''ora di inizio della gara deve essere uguale o successiva all''ora prevista!');
end if;

if to_date(:NEW.ora_fine_gara, 'HH24:MI') < to_date(:NEW.ora_inizio_gara, 'HH24:MI') then
	raise_application_error(-20006,'L''ora di fine della gara deve essere uguale o successiva all''ora di inizio!');
end if;

if inserting then
	if :NEW.nome_sponsor is not null then
		select discriminatore_sponsor into tipo_sponsor
		from Sponsor where nome_sponsor = :NEW.nome_sponsor;
	end if;
	
	if (tipo_sponsor <> 'gara') and (tipo_sponsor <> 'Gara') and (tipo_sponsor <> 'GARA') then
		raise_application_error(-20007,'Lo sponsor inserito non e'' uno sponsor gara!');
	end if;

end if;

end;