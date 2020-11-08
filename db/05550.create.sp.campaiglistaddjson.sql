call TRACE('create SP CampaignlistAddJSON');

create or replace function CampaignlistAddJSON(doc JSONB, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_campaign_id campaignlist.campaign_id%TYPE;
_name campaignlist.name%TYPE;
_campaignfile_id campaignlist.campaignfile_id%TYPE;
_flow campaignlist.flow%TYPE;
isValid bool;
nameInvalid bool;
errors JSONB;
_id campaignlist.id%TYPE;
begin

select doc->>'campaign_id' into _campaign_id;
select doc->>'name' into _name;
select doc->>'campaignfile_id' into _campaignfile_id;
select doc->>'flow' into _flow;

call LOGJSONADD( concat('CampaignlistAddJSON1 name=',_name,' campaign_id=', _campaign_id, ' campaignfile_id=', _campaignfile_id), doc);

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


isValid := true;
nameInvalid := false;

errors := '{}';
_js:='{}';

if _campaign_id is null or not exists (select 1 from campaign c where c.id=_campaign_id) then
  isValid:=false;
  select jsetstr(errors, 'campaign_id', 'Campaign is required') into errors;
end if;

if _name is null or length(_name)=0 then
  isValid:=false;
  select jsetstr(errors, 'name', 'Name is required') into errors;
end if;

if not nameInvalid and exists (select 1 from campaignlist where name=_name and campaign_id=_campaign_id) then
  isValid:=false;
   select jsetstr(errors, 'name', 'Name must be unique') into errors;
end if;

if _campaignfile_id is not null and not exists (select 1 from campaignfile c where c.id=_campaignfile_id) then
  isValid:=false;
  select jsetstr(errors, 'campaignfile_id', 'Invalid file selected') into errors;
end if;

call LOGJSONADD( concat('CampaignlistAddJSON2 isValid=',isValid, ' name=', _name, ' _campaign_id=', _campaign_id, ' campaignfile_id=', _campaignfile_id ), errors );

if isValid then
  insert into campaignlist(name, campaign_id, campaignfile_id, flow)
  select _name, _campaign_id, _campaignfile_id, _flow;
  select campaignlist.id into _id from campaignlist where campaignlist.name=_name;
  select jsetint('{}', 'id', _id) into _js;
  select SuccessWithPayloadJSON(_js) into _js;
else
  select ErrsJSON(errors) into _js;
end if;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestCampaignlistAddJSON');

create or replace procedure TestCampaignlistAddJSON()
as $$
declare
_js JSONB;
begin

call TRACE('1TestCampaignlistAddJSON1');

_js:='{ "name": "testcampaignlist", "campaign_id": 1 }';

select jsetjson(_js, 'flow', '{"start": 1}') into _js;

select CampaignlistAddJSON(_js, testsession2()) into _js;

call TRACE( concat('TestCampaignlistAddJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignlistAddJSON();

