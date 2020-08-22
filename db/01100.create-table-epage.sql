drop domain if exists TYPE_EPAGEID cascade;
CREATE DOMAIN TYPE_EPAGEID bigint;

drop domain if exists TYPE_EPAGENAME cascade;
CREATE DOMAIN TYPE_EPAGENAME varchar(100);

drop domain if exists TYPE_EPAGELABEL cascade;
CREATE DOMAIN TYPE_EPAGELABEL varchar(50);

drop domain if exists TYPE_EPAGEQUERY cascade;
CREATE DOMAIN TYPE_EPAGEQUERY varchar(50);

drop domain if exists TYPE_EPAGETYPE cascade;
CREATE DOMAIN TYPE_EPAGETYPE varchar(20);


drop domain if exists TYPE_EPAGEPKNAME cascade;
CREATE DOMAIN TYPE_EPAGEPKNAME varchar(20);

drop domain if exists TYPE_EPAGEENTITY cascade;
CREATE DOMAIN TYPE_EPAGEENTITY varchar(100);


drop table if exists epageaction;
drop table if exists epagefield;
drop table if exists epage;

call TRACE('create table epage');

create table epage(
  id SERIAL PRIMARY KEY,
  entity TYPE_EPAGEENTITY,
  name TYPE_EPAGENAME NOT NULL,
  label TYPE_EPAGELABEL,
  type TYPE_EPAGETYPE NOT NULL,  -- list, edit
  query TYPE_EPAGEQUERY,
  pkname TYPE_EPAGEPKNAME,
  ordno int
);

create unique index ix_epage_epagename on epage(name);
------------------------------------------------------------------


drop domain if exists TYPE_EPAGEFIELDID cascade;
CREATE DOMAIN TYPE_EPAGEFIELDID bigint;

drop domain if exists TYPE_EPAGEFIELDNAME cascade;
CREATE DOMAIN TYPE_EPAGEFIELDNAME varchar(50);

drop domain if exists TYPE_EPAGEFIELDLABEL cascade;
CREATE DOMAIN TYPE_EPAGEFIELDLABEL varchar(50);


drop domain if exists TYPE_EPAGEFIELDTYPE cascade;
CREATE DOMAIN TYPE_EPAGEFIELDTYPE varchar(20);

drop domain if exists TYPE_EPAGEFIELDTAB cascade;
CREATE DOMAIN TYPE_EPAGEFIELDTAB varchar(20);

drop domain if exists TYPE_EPAGEFIELDQUERY cascade;
CREATE DOMAIN TYPE_EPAGEFIELDQUERY varchar(100);


call TRACE('create table epagefield');

create table epagefield (
  id SERIAL PRIMARY KEY,
  name TYPE_EPAGEFIELDNAME NOT NULL,
  label TYPE_EPAGEFIELDLABEL,
  type TYPE_EPAGEFIELDTYPE,
  query TYPE_EPAGEFIELDQUERY,
  tab TYPE_EPAGEFIELDTAB,
  ordno int,
  epageid TYPE_EPAGEID,
  FOREIGN KEY(epageid) references epage(id) on delete cascade
);

create unique index ix_epagefield_epageid_name on epagefield(epageid, name);
------------------------------------------------------------------

drop domain if exists TYPE_EPAGEACTIONID cascade;
CREATE DOMAIN TYPE_EPAGEACTIONID bigint;

drop domain if exists TYPE_EPAGEACTIONNAME cascade;
CREATE DOMAIN TYPE_EPAGEACTIONNAME varchar(41);

drop domain if exists TYPE_EPAGEACTIONLABEL cascade;
CREATE DOMAIN TYPE_EPAGEACTIONLABEL varchar(42);
drop domain if exists TYPE_EPAGEACTIONQUERY cascade;
CREATE DOMAIN TYPE_EPAGEACTIONQUERY varchar(43);
drop domain if exists TYPE_EPAGEACTIONTYPE cascade;
CREATE DOMAIN TYPE_EPAGEACTIONTYPE varchar(20);

drop domain if exists TYPE_EPAGEACTIONCONFIRM cascade;
CREATE DOMAIN TYPE_EPAGEACTIONCONFIRM varchar(200);

drop domain if exists TYPE_EPAGEACTIONISITEMACTION cascade;
CREATE DOMAIN TYPE_EPAGEACTIONISITEMACTION bool;

drop domain if exists TYPE_EPAGEACTIONLOCATION cascade;
CREATE DOMAIN TYPE_EPAGEACTIONLOCATION varchar(50);

drop domain if exists TYPE_EPAGEACTIONSTYLE cascade;
CREATE DOMAIN TYPE_EPAGEACTIONSTYLE varchar(50);



call TRACE('create table epageaction');

create table epageaction (
  id SERIAL PRIMARY KEY,
  name TYPE_EPAGEACTIONNAME NOT NULL,
  label TYPE_EPAGEACTIONLABEL,
  type TYPE_EPAGEACTIONTYPE NOT NULL,
  nextpage TYPE_EPAGENAME,
  confirm TYPE_EPAGEACTIONCONFIRM,
  query TYPE_EPAGEACTIONQUERY,
  isitemaction TYPE_EPAGEACTIONISITEMACTION NOT NULL default false,
  ordno int NOT NULL,
  epageid TYPE_EPAGEID,
  location TYPE_EPAGEACTIONLOCATION,
  style TYPE_EPAGEACTIONSTYLE,
  FOREIGN KEY(epageid) references epage(id) on delete cascade
);

create unique index ix_epageaction_epageid_name on epageaction(id, name);
------------------------------------------------------------------

