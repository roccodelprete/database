create or replace trigger control_pilota_quali
before insert or update on Disputa_Qualifica
for each row

declare

pos_q1	Disputa_Qualifica.posizione_finale_qualifica%type;
pos_q2	Disputa_Qualifica.posizione_finale_qualifica%type;
exc 	exception;

begin

if :NEW.sessione_qualifica = 'Q2' or :NEW.sessione_qualifica = 'q2' then
	select posizione_finale_qualifica into pos_q1
	from Disputa_Qualifica where data_gara = :NEW.data_gara and
	(sessione_qualifica = 'Q1' or sessione_qualifica = 'q1') and
	numero_pilota = :NEW.numero_pilota;
	
	if pos_q1 >= 16 and pos_q1 <= 20 then
		raise exc;
	end if;

elsif :NEW.sessione_qualifica = 'Q3' or :NEW.sessione_qualifica = 'q3' then
	select posizione_finale_qualifica into pos_q1
	from Disputa_Qualifica where data_gara = :NEW.data_gara and
	(sessione_qualifica = 'Q1' or sessione_qualifica = 'q1') and
	numero_pilota = :NEW.numero_pilota;
	
	select posizione_finale_qualifica into pos_q2
	from Disputa_Qualifica where data_gara = :NEW.data_gara and
	(sessione_qualifica = 'Q2' or sessione_qualifica = 'q2') and
	numero_pilota = :NEW.numero_pilota;
	
	if (pos_q1 >= 16 and pos_q1 <= 20) or (pos_q2 >= 11 and pos_q2 <= 15) then
		raise exc;
	end if;
	
end if;

exception when exc then
	if pos_q1 >= 16 and pos_q1 <= 20 then
		raise_application_error(-20001,'Il pilota è stato eliminato in Q1');
	elsif pos_q1 <= 16 and (pos_q2 >= 11 and pos_q2 <= 15) then
		raise_application_error(-20002,'Il pilota è stato eliminato in Q2');
	end if;
end;