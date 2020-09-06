

call TRACE('create table menu');

create table menu(
id SERIAL PRIMARY KEY,
name varchar(100) NOT NULL,
icon varchar(100),
url varchar(100),
parent_id BIGINT,
ordno INT NOT NULL,
epage_id INT,
foreign key(parent_id) references menu(id) on delete cascade,
foreign key(epage_id) references epage(id) on delete cascade
);

create unique index ix_menu_name on menu(name);
------------------------------------------------------------------

call EntityRegister('menu', 'menu');


