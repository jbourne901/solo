
drop domain if exists TYPE_CAMPAIGNLISTID;
CREATE DOMAIN TYPE_CAMPAIGNLISTID bigint;

drop domain if exists TYPE_CAMPAIGNLISTNAME;
CREATE DOMAIN TYPE_CAMPAIGNLISTNAME varchar(40);



call TRACE('create table campaignlist');

drop table if exists campaignlist;

create table campaignlist (
id SERIAL PRIMARY KEY,
name TYPE_CAMPAIGNLISTNAME not null,
campaignfile_id TYPE_CAMPAIGNFILEID NULL references campaignfile(id) ON DELETE SET NULL,
campaign_id TYPE_CAMPAIGNID NOT NULL references campaign(id) ON DELETE SET NULL,
flow JSONB
);

create unique index ix_campaignlist_campaign_id_name on campaignlist(id,name);


------------------------------------------------------------------

call EntityRegister('campaignlist', 'campaignlist');
