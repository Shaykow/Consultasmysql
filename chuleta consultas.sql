SELECT 
    id_jornada,
    concat(Usuarios_informacion.`Nombre`,' ',Usuarios_informacion.`Apellido1`,' ',Usuarios_informacion.`Apellido2`) As Nombre, 
    Tipo_Registro_Jornada.`tipo_registro_jornada` as 'tipo_de_registro',
    case when Rectificaciones_Jornada_Empleado.`nueva_fecha` then Rectificaciones_Jornada_Empleado.`nueva_fecha`
         else Registro_Jornada.`fecha` end as 'fecha_y_hora_de_registro'
       
FROM (((`Registro_Jornada` inner join Tipo_Registro_Jornada using(`id_tipo_registro_jornada`)) left join Rectificaciones_Jornada_Empleado using (`id_jornada`))left join Usuarios on Registro_Jornada.`id_usuario`=Usuarios.`id`) left join  Usuarios_informacion on Usuarios.`Usuario`=Usuarios_informacion.`DNI`


select distinct * from Rectificaciones_Jornada_Empleado inner join Registro_Jornada using id_jornada


SELECT * FROM (((`Registro_Jornada` inner join Tipo_Registro_Jornada using(`id_tipo_registro_jornada`)) left join Rectificaciones_Jornada_Empleado using (`id_jornada`))left join Usuarios on Registro_Jornada.`id_usuario`=Usuarios.`id`) left join  Usuarios_informacion on Usuarios.`Usuario`=Usuarios_informacion.`DNI`


SELECT 
concat(Usuarios_informacion.`Nombre`,' ',Usuarios_informacion.`Apellido1`,' ',Usuarios_informacion.`Apellido2`) As Nombre, 
Tipo_Registro_Jornada.`tipo_registro_jornada` as 'tipo_de_registro',
Registro_Jornada.`fecha` as 'fecha_y_hora_de_registro'
FROM (((`Registro_Jornada` inner join Tipo_Registro_Jornada using(`id_tipo_registro_jornada`)) left join Rectificaciones_Jornada_Empleado using (`id_jornada`))left join Usuarios on Registro_Jornada.`id_usuario`=Usuarios.`id`) left join  Usuarios_informacion on Usuarios.`Usuario`=Usuarios_informacion.`DNI`

/*creacion vista*/

CREATE VIEW 'Vista_Registro_Jornada' AS SELECT 
    id_jornada,
    concat(Usuarios_informacion.`Nombre`,' ',Usuarios_informacion.`Apellido1`,' ',Usuarios_informacion.`Apellido2`) As Nombre, 
    Tipo_Registro_Jornada.`tipo_registro_jornada` as 'tipo_de_registro',
    `Rectificaciones_Jornada_Supervisor`.`nueva_fecha` as rectificacion_supervisor,
    case when `aplicacion`.`Rectificaciones_Jornada_Empleado`.`nueva_fecha` then `aplicacion`.`Rectificaciones_Jornada_Empleado`.`nueva_fecha`
         else Registro_Jornada.`fecha` end as 'fecha_y_hora_de_registro'
       
FROM ((((`Registro_Jornada` inner join Tipo_Registro_Jornada using(`id_tipo_registro_jornada`)) 
left join Rectificaciones_Jornada_Empleado using (`id_jornada`))
left join Rectificaciones_Jornada_Supervisor using (`id_jornada`))
left join Usuarios on Registro_Jornada.`id_usuario`=Usuarios.`id`) 
left join  Usuarios_informacion on Usuarios.`Usuario`=Usuarios_informacion.`DNI`



select `aplicacion`.`Registro_Jornada`.`id_usuario` AS `id_usuario`,
`aplicacion`.`Registro_Jornada`.`id_jornada` AS `id_jornada`,
`aplicacion`.`Registro_Jornada`.`codigo_jornada` AS `codigo_jornada`,
concat(`aplicacion`.`Usuarios_informacion`.`Nombre`,' ',`aplicacion`.`Usuarios_informacion`.`Apellido1`,' ',`aplicacion`.`Usuarios_informacion`.`Apellido2`) AS `Nombre`,
`aplicacion`.`Tipo_Registro_Jornada`.`tipo_registro_jornada` AS `tipo_de_registro`,
`aplicacion`.`Rectificaciones_Jornada_Supervisor`.`nueva_fecha` AS `rectificacion_supervisor`,
(case when `aplicacion`.`Rectificaciones_Jornada_Empleado`.`nueva_fecha` 
then `aplicacion`.`Rectificaciones_Jornada_Empleado`.`nueva_fecha` 
else `aplicacion`.`Registro_Jornada`.`fecha` end) AS `fecha_y_hora_de_registro`,
(case when `aplicacion`.`Rectificaciones_Jornada_Supervisor`.`nueva_fecha` 
then 2 when `aplicacion`.`Rectificaciones_Jornada_Empleado`.`nueva_fecha` 
then 1 
else 0 end) AS `Id_rectificacion`,
`aplicacion`.`Rectificaciones_Jornada_Empleado`.`observaciones` AS `observaciones_Empleado`,
`aplicacion`.`Rectificaciones_Jornada_Supervisor`.`observaciones` AS `observaciones_Supervisor`,
`aplicacion`.`Registro_Jornada`.`geolocalizacion` AS `geolocalizacion` 
from (((((`aplicacion`.`Registro_Jornada` join `aplicacion`.`Tipo_Registro_Jornada` 
on((`aplicacion`.`Registro_Jornada`.`id_tipo_registro_jornada` = `aplicacion`.`Tipo_Registro_Jornada`.`id_tipo_registro_jornada`))) 
left join `aplicacion`.`Rectificaciones_Jornada_Empleado` 
on((`aplicacion`.`Registro_Jornada`.`id_jornada` = `aplicacion`.`Rectificaciones_Jornada_Empleado`.`id_jornada`))) 
left join `aplicacion`.`Rectificaciones_Jornada_Supervisor` on((`aplicacion`.`Registro_Jornada`.`id_jornada` = `aplicacion`.`Rectificaciones_Jornada_Supervisor`.`id_jornada`))) 
left join `aplicacion`.`Usuarios` on((`aplicacion`.`Registro_Jornada`.`id_usuario` = `aplicacion`.`Usuarios`.`Id`))) 
left join `aplicacion`.`Usuarios_informacion` on((`aplicacion`.`Usuarios`.`Usuario` = `aplicacion`.`Usuarios_informacion`.`DNI`)))



/*Procedimiento horas */

DELIMITER //
CREATE PROCEDURE p_calculadorhoras (IN usuario INT, entrada DATETIME, salida DATETIME OUT horasrectificadas)
    BEGIN

    
    Create table if not exists contador_rectificaciones;
    truncate table contador_rectificaciones;
    insert into contador_rectificaciones
    select nombre,
    id_jornada,
    TIMEDIFF( fecha_y_hora_de_registro, rectificacion_supervisor) as rectificacion
    from Vista_Registro_Jornada 
    where id_usuario = "usuario"
    and fecha_y_hora_de_registro >= "entrada" 
    and fecha_y_hora_de_registro <= "salida";

    

    END//
DELIMITER ;

SELECT SUM(rectificacion) as sumatorio_rectificaciones from contador_rectificaciones

/* Prodecimiento horas 2 */

CREATE PROCEDURE p_calculadorhoras (IN usuario INT, entrada DATETIME, salida DATETIME)
    BEGIN

    select nombre,
    id_jornada,
    codigo_jornada,
    case when rectificacion_supervisor 
    then  rectificacion_supervisor
    else fecha_y_hora_de_registro end) AS `fecha_y_hora_de_registro`,
    
    GROUP BY(codigo_jornada)

    from Vista_Registro_Jornada 
    where id_usuario = "usuario"
    and fecha_y_hora_de_registro >= "entrada" 
    and fecha_y_hora_de_registro <= "salida";

    

    END//
DELIMITER ;

Create table if not exists pruebahoras (
select distinct v2.Nombre,
    v2.id_jornada,
    v2.codigo_jornada,
    (case when Vista_Registro_Jornada.rectificacion_supervisor 
    then  Vista_Registro_Jornada.rectificacion_supervisor
    else Vista_Registro_Jornada.fecha_y_hora_de_registro end) AS `fecha_entrada`,
    (case when v2.rectificacion_supervisor 
    then  v2.rectificacion_supervisor
    else v2.fecha_y_hora_de_registro end) AS `fecha_salida`
    

    from Vista_Registro_Jornada inner join Vista_Registro_Jornada as v2 on Vista_Registro_Jornada.codigo_jornada = v2.codigo_jornada
    
    where v2.id_usuario = 2000
    and Vista_Registro_Jornada.fecha_y_hora_de_registro >= '2019-05-01 11:24:26' 
    and v2.fecha_y_hora_de_registro <= '2019-05-30 13:39:26'
    and Vista_Registro_Jornada.id_jornada < v2.id_jornada
    and Vista_Registro_Jornada.codigo_jornada = v2.codigo_jornada);

-- SELECT SUM(TIMEDIFF(fecha_salida, fecha_entrada)) as Horas_trabajadas from pruebahoras;
SELECT FROM_UNIXTIME(SUM(UNIX_TIMESTAMP(fecha_salida) - UNIX_TIMESTAMP(fecha_entrada)), '%H:%i') as Horas_trabajadas from pruebahoras;
