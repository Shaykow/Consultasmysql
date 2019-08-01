use webexamen;
drop trigger if exists t1;
delimiter //

Create trigger t1 before delete on solicitudes for each row 
begin
	declare vusuario varchar(45);
    declare vfecha_elim datetime;
    declare vcorreo varchar(45);
    declare vfecha_sol date;
    
    set vusuario= user();
    set vfecha_elim= curdate();
    set vcorreo = old.correo;
    set vfecha_sol = old.fecha_solicitud;
    
    insert into log_solicitudes_borradas(usuario,fechahora_eliminacion,correo,fecha_solicitud) 
    values (vusuario, vfecha_elim, vcorreo, vfecha_sol);
end//
