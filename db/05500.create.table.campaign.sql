drop domain if exists TYPE_CAMPAIGNID;
CREATE DOMAIN TYPE_CAMPAIGNID bigint;

drop domain if exists TYPE_CAMPAIGNNAME;
CREATE DOMAIN TYPE_CAMPAIGNNAME varchar(40);


call TRACE('create table campaign');

drop table if exists campaign;

create table campaign (
id SERIAL PRIMARY KEY,
name TYPE_CAMPAIGNNAME not null
);

create unique index ix_campaign_name on campaign(name);


------------------------------------------------------------------

call EntityRegister('campaign', 'campaign');
