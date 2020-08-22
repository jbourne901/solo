
call TRACE('create table agentscenario');

drop table if exists agentscenario;

create table agentscenario (
id SERIAL PRIMARY KEY,
name varchar(40) not null,
flow JSONB
);

create unique index ix_agentscenario_name on agentscenario(name);


drop table if exists agentscenariotemplate;

create table agentscenariotemplate (
id SERIAL PRIMARY KEY,
name varchar(40),
label varchar(40),
ports JSONB,
flow JSONB
);


------------------------------------------------------------------

call EntityRegister('agentscenario', 'agentscenario');
