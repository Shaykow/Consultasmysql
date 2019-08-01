use webexamen;
drop procedure if exists listado_conversacion;
delimiter //

create procedure listado_conversacion(in pidconversacion int)
begin

-- Declaro las variables
declare vidconversacion int;
declare vcreador varchar(60);
declare vfechaconver date;
declare vtema varchar(256);
declare vresultado text;
declare vcorreo varchar(60);
declare vfecha datetime;
declare vmensaje text;
declare vcontador int default 0;
declare vfin int default 0;
declare cursor1 cursor for select correo, fecha, mensaje from mensajes where idconversacion=pidconversacion;

-- Declaro un handler para el final
declare continue handler for SQLSTATE '02000' set vfin=1;

-- Comienzo haciendo la cabecera
set vidconversacion= pidconversacion;
select creador into vcreador from conversacion where idconversacion=pidconversacion;
select fecha into vfechaconver from conversacion where idconversacion=pidconversacion;
select tema into vtema from conversacion where idconversacion=pidconversacion;

set vresultado= concat("Conversacion:",vidconversacion,"   Creador:",vcreador,"/n","FECHA DE CREACION:",vfechaconver,"   TEMA:",vtema,"/n","   MENSAJES DE LA CONVERSACION","/n");

-- Ahora haremos el cuerpo (los mensajes) con un cursor, que luego meteremos en vresultado concatenandolo con
-- lo que ya tenemos dentro de el

open cursor1;
	fetch cursor1 into vcorreo, vfecha, vmensaje;
	set vcontador= vcontador+1;
	set vresultado = concat(vresultado,"Mensaje",vcontador,": de",vcorreo,"-",vfecha,"/n",vmensaje);
    
	while vfin=0 do
		fetch cursor1 into vcorreo, vfecha, vmensaje;
		set vcontador= vcontador+1;
		set vresultado = concat(vresultado,"Mensaje",vcontador,": de",vcorreo,"-",vfecha,"/n",vmensaje,"/n");
	end while;
close cursor1;

set vresultado = concat(vresultado,"Numero de mensajes de la conversacion: ",vcontador);

-- Finalmente sacamos el informe en un fichero
select vresultado into outfile "listado.txt";

end//

