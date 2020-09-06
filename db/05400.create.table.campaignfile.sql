
drop domain if exists TYPE_CAMPAIGNFILEID;
CREATE DOMAIN TYPE_CAMPAIGNFILEID bigint;

drop domain if exists TYPE_CAMPAIGNFILENAME;
CREATE DOMAIN TYPE_CAMPAIGNFILENAME varchar(40);


call TRACE('create table campaignfile');

drop table if exists campaignfile;

create table campaignfile (
id SERIAL PRIMARY KEY,
name TYPE_CAMPAIGNFILENAME not null
);

create unique index ix_campaignfile_name on campaignfile(name);


------------------------------------------------------------------

call EntityRegister('campaignfile', 'campaignfile');
