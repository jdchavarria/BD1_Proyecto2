LOAD DATA 
infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ICE-FUENTE-MEJORADO.csv'
INTO TABLE temporal
character SET utf8
fields terminated by ';'
enclosed by'"'
lines terminated by '\n'
ignore 1 rows;