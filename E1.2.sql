use webexamen;
drop trigger if exists t2;
delimiter //

Create trigger t2 after insert on solicitudes for each row 
begin

	declare vresultado text;
    declare vcorreo varchar(45);
    
    set vcorreo = new.correo;

	set vresultado = concat("<html>
<head>
</head>
<body>
Bienvenido a la web<br>
<br>
Ha solicitado darse de alta en nuestra pagina web con este <br>
correo:",vcorreo,"<br><br>Para confirmar su solicitud haga clic en el siguiente enlace:<br>
<a>'href=http://web.com/confirmacion.php?correo=",vcorreo,"'></a>
</body>
</html>");

select vresultado into outfile "correo.txt";
end//