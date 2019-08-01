use webexamen;
drop function if exists revisar_solicitud;
delimiter //

create function revisar_solicitud(pcorreo varchar(45)) returns int deterministic
begin

declare vcorreo varchar(45);
declare vsi int default 1;
declare vno int default 0;

select correo into vcorreo from usuarios_registrados where correo=pcorreo;

	if vcorreo is not null then
    return vsi;
    
    else
    return vno;

	end if;

end//
