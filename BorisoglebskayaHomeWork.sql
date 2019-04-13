--------------------------------------------------------------------------------
--CREATE
--------------------------------------------------------------------------------
CREATE TABLE OBJECTS (
  object_id NUMBER PRIMARY KEY,
  parent_id NUMBER,
  object_type_id NUMBER NOT NULL,
  name VARCHAR2(255),
  description VARCHAR2(255),
  order_number NUMBER
);

CREATE TABLE OBJECT_TYPES (	
  object_type_id NUMBER PRIMARY KEY,
  parent_id NUMBER,
  name VARCHAR2(255) UNIQUE,
  description VARCHAR2(255),
  properties VARCHAR2(255)
);

CREATE TABLE ATTR (
  attr_id NUMBER PRIMARY KEY,
  attr_type_id NUMBER NOT NULL,
  attr_group_id NUMBER NOT NULL,																																						
  name VARCHAR2(255) UNIQUE,
  description VARCHAR2(255),
  ismultiple NUMBER(1),
  properties VARCHAR2(45)
);

CREATE TABLE PARAMS (
  attr_id NUMBER NOT NULL,
  object_id NUMBER NOT NULL,
  value VARCHAR2(255),
  date_value DATE,
  show_order NUMBER
);

CREATE TABLE ATTR_TYPES (
  attr_type_id NUMBER PRIMARY KEY,
  name VARCHAR2(255) UNIQUE,
  properties VARCHAR2(255)
);

CREATE TABLE REFERENCES (
  attr_id NUMBER NOT NULL,
  object_id NUMBER NOT NULL,
  reference NUMBER NOT NULL,
  show_order NUMBER
);

CREATE TABLE ATTR_BINDS (
  object_type_id NUMBER NOT NULL,
  attr_id NUMBER NOT NULL,
  options VARCHAR2(255) NOT NULL,
  isrequired NUMBER(1),
  default_value VARCHAR2(255)
);

CREATE TABLE ATTR_GROUPS (
  attr_group_id NUMBER PRIMARY KEY,
  name VARCHAR2(255) UNIQUE,
  properties VARCHAR2(255)
);



--------------------------------------------------------------------------------
--ALTER
--------------------------------------------------------------------------------
ALTER TABLE OBJECTS ADD FOREIGN KEY
(parent_id) REFERENCES OBJECTS (object_id);
ALTER TABLE OBJECTS ADD FOREIGN KEY
(object_type_id) REFERENCES OBJECT_TYPES (object_type_id);

ALTER TABLE OBJECT_TYPES ADD FOREIGN KEY
(parent_id) REFERENCES OBJECT_TYPES (object_type_id);

ALTER TABLE ATTR ADD FOREIGN KEY
(attr_type_id) REFERENCES ATTR_TYPES(attr_type_id);
ALTER TABLE ATTR ADD FOREIGN KEY
(attr_group_id) REFERENCES ATTR_GROUPS(attr_group_id);

ALTER TABLE PARAMS ADD FOREIGN KEY
(attr_id) REFERENCES ATTR(attr_id) ON DELETE CASCADE;
ALTER TABLE PARAMS ADD FOREIGN KEY
(object_id) REFERENCES OBJECTS(object_id) ON DELETE CASCADE;

ALTER TABLE REFERENCES ADD FOREIGN KEY
(attr_id) REFERENCES ATTR(attr_id) ON DELETE CASCADE;
ALTER TABLE REFERENCES ADD FOREIGN KEY
(object_id) REFERENCES OBJECTS(object_id) ON DELETE CASCADE;
ALTER TABLE REFERENCES ADD FOREIGN KEY
(reference) REFERENCES OBJECTS(object_id) ON DELETE CASCADE;

ALTER TABLE ATTR_BINDS ADD FOREIGN KEY
(object_type_id) REFERENCES OBJECT_TYPES(object_type_id);
ALTER TABLE ATTR_BINDS ADD FOREIGN KEY
(attr_id) REFERENCES ATTR(attr_id);

--------------------------------------------------------------------------------
--INSERT
--------------------------------------------------------------------------------

INSERT INTO OBJECT_TYPES
VALUES ( 1, NULL, 'TV', 'Телевизор', '...' );

INSERT INTO OBJECT_TYPES
VALUES ( 2, 1, 'Plasma TV', 'Плазменный телевизор', '...' );

INSERT INTO OBJECT_TYPES
VALUES ( 3, 1, 'LCD TV', 'Жидкокристаллический телевизор', '...' );

INSERT INTO OBJECT_TYPES
VALUES ( 4, NULL, 'Tablet computer', 'Планшет', '...' );

INSERT INTO OBJECT_TYPES
VALUES ( 5, NULL, 'eBook', 'Электронная книга', '...' );
--------------------------------------------------------------------------------

INSERT INTO OBJECTS
VALUES ( 1, NULL, 1, 'LG 50UK6300', 'TV LG', 1 );

INSERT INTO OBJECTS
VALUES ( 2, NULL, 2, 'Samsung UE55NU7670U', 'TV Samsung', 2 );

INSERT INTO OBJECTS
VALUES ( 3, NULL, 4, 'Huawei MediaPad T3', 'Tablet Huawei', 3 );

INSERT INTO OBJECTS
VALUES ( 4, NULL, 4, 'Android Huawei MediaPad', 'Tablet Huawei', 3 );

INSERT INTO OBJECTS
VALUES ( 5, NULL, 5, 'PocketBook 740', 'eBook PocketBook', 1 );
--------------------------------------------------------------------------------
INSERT INTO ATTR_TYPES
VALUES ( 1, 'RemoteControl', '...' );

INSERT INTO ATTR_TYPES
VALUES ( 2, 'Diagonal', '...' );

INSERT INTO ATTR_TYPES
VALUES ( 3, 'InputMethod', '...' );

INSERT INTO ATTR_TYPES
VALUES ( 4, 'OperatingSystem', '...' );

INSERT INTO ATTR_TYPES
VALUES ( 5, 'Number of pixels', '...' );

INSERT INTO ATTR_TYPES
VALUES ( 6, 'NumColor', 'Number of colors' );
--------------------------------------------------------------------------------
INSERT INTO ATTR_GROUPS
VALUES ( 1, 'TV', 'TV attributes' );

INSERT INTO ATTR_GROUPS
VALUES ( 2, 'Tablet', 'Tablet attributes' );

INSERT INTO ATTR_GROUPS
VALUES ( 3, 'eBook', 'eBook attributes' );

--------------------------------------------------------------------------------
INSERT INTO ATTR
VALUES ( 1, 2, 1, 'Diagonal', 'Screen diagonal', 0, '...' );

INSERT INTO ATTR
VALUES ( 2, 3, 2, 'InputTablet', 'Input method for tablet', 1, '...' );

INSERT INTO ATTR
VALUES ( 3, 6, 3, 'ColorEBook', 'Number of colors in eBook', 0, '...' );

INSERT INTO ATTR
VALUES ( 4, 3, 3, 'InputEBook', 'Input method for eBook', 1, '...' );

INSERT INTO ATTR
VALUES ( 5, 4, 2, 'TabletOS', 'Operating system on tablet', 1, '...' );
--------------------------------------------------------------------------------

INSERT INTO ATTR_BINDS
VALUES ( 1, 1, 'Diagonal', 0, NULL );

INSERT INTO ATTR_BINDS
VALUES ( 4, 2, 'Input', 1, NULL );

INSERT INTO ATTR_BINDS
VALUES ( 5, 3, 'NumColor', 0, NULL );

INSERT INTO ATTR_BINDS
VALUES ( 5, 4, 'Input', 1, NULL );

INSERT INTO ATTR_BINDS
VALUES ( 4, 5, 'OS', 1, NULL );
--------------------------------------------------------------------------------

INSERT INTO REFERENCES
VALUES ( 1, 2, 1, 1 );

INSERT INTO REFERENCES
VALUES ( 5, 4, 3, 1 );
--------------------------------------------------------------------------------

INSERT INTO PARAMS
VALUES ( 1, 1, '50', NULL, 1 );

INSERT INTO PARAMS
VALUES ( 1, 2, '55', NULL, 1 );

INSERT INTO PARAMS
VALUES ( 5, 3, 'Android', NULL, 1 );

INSERT INTO PARAMS
VALUES ( 5, 4, 'Android', NULL, 1 );

INSERT INTO PARAMS
VALUES ( 4, 5, 'TouchScreen', NULL, 1 );

INSERT INTO PARAMS
VALUES ( 4, 5, 'ControlButtons', NULL, 1 );



--1. получение информации обо всех атрибутах(учитывая только атрибутную группу 
--и атрибутные типы) (attr_id, attr_name, attr_group_id, attr_group_name, 
--attr_type_id, attr_type_name)
select attr.attr_id, attr.name as attr_name, attr.attr_group_id, attr_groups.name as attr_group_name, attr.attr_type_id, attr_types.name as attr_type_name
from attr
join attr_groups on  attr.attr_group_id = attr_groups.attr_group_id
join attr_types on attr.attr_type_id = attr_types.attr_type_id;

--2. получение всех атрибутов для заданного  объектного типа, без учета 
--наследования (attr_id, attr_name )
select attr.attr_id, attr.name as attr_name 
from attr
join attr_binds on attr.attr_id = attr_binds.attr_id 
where object_type_id = 5;

--3. получение иерархии от(объектных типов)  для заданного объектного 
--типа(нужно получить иерархию наследования)  (ot_id, ot_name, level)
select object_type_id as ot_id, name as ot_name, level
from object_types
start with object_type_id = 2
connect by prior parent_id = object_type_id;

--4. получение вложенности объектов для заданного объекта(нужно получить 
--иерархию вложенности) (obj_id, obj_name, level)
select object_id as obj_id, name as obj_name, level
from objects
start with object_id = 3
connect by prior parent_id = object_id;

--5. получение объектов заданного объектного типа(учитывая только наследование от)
--(ot_id, ot_name, obj_id, obj_name)
select object_type_id as ot_id, object_types.name as ot_name, object_id as obj_id, objects.name as obj_name 
from  objects 
join object_types using (object_type_id)
where object_type_id in (
        select object_type_id from object_types
        start with object_type_id = 2
        connect by object_type_id = prior parent_id);

--6. получение значений всех атрибутов(всех возможных типов) для заданного 
--объекта(без учета наследования от) (attr_id, attr_name, value)
select attr_id, attr.name as attr_name, value from (
    select * from (
        --id атрибутов, которые могут быть у объектного типа заданного объекта
        select attr_id
        from objects
        right join attr_binds 
        using (object_type_id)
        where object_type_id = (
            select object_type_id 
            from objects
            where object_id = 3
        ) 
    )
    left join ( 
        --id атрибутов и их значения из таблиц params и references для заданного 
        --объекта
        select attr_id, 
            case
                when value is null then to_char(date_value)
                else value
            end as value
        from params
        where params.object_id = 3
        union
        select attr_id, to_char(reference) as value
        from references
        where references.object_id = 3
    )
    using (attr_id)
)
join attr
using (attr_id);
 
--7. получение ссылок на заданный объект(все объекты, которые ссылаются на текущий)
--(ref_id, ref_name)
select distinct object_id as ref_id, objects.name as ref_name
from references 
join objects using (object_id)
where reference = 3;

--8. получение значений всех атрибутов(всех возможных типов, без повторяющихся атрибутов) для заданного объекта
--( с учетом наследования от) вывести в виде см. п.6 (attr_id, attr_name, value)
select distinct attr_id, attr.name as attr_name, value from (
    select * from (
        --id атрибутов, которые могут быть у иерархии объектных типов заданного объекта
        select attr_id
        from objects
        right join attr_binds 
        using (object_type_id)
        where object_type_id in (
        --получение иерархии наследования объектных типов заданного объекта
            select object_type_id
            from object_types
	    start with object_type_id = (select object_type_id from objects where object_id = 2)
            connect by prior parent_id = object_type_id
        )  
    )
    left join ( -- исключение повторяющихся
        --id атрибутов и их значения из таблиц params и references для заданного объекта
        select attr_id, object_id,
            case
                when value is null then to_char(date_value)
                else value
            end as value
        from params
        union
        select attr_id, object_id, to_char(reference) as value
        from references
    )
    using (attr_id)
    where object_id in (
	 select object_id from objects
	 start with object_id = 2
	 connect by prior object_id = parent_id) 
)
join attr
using (attr_id);
