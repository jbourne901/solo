call TRACE('create SP CampaignlistUpdateJSON');

create or replace function CampaignlistUpdateJSON(doc JSONB, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_campaign_id campaignlist.campaign_id%TYPE;
_name campaignlist.name%TYPE;
_id campaignlist.id%TYPE;
_campaignfile_id campaignlist.campaignfile_id%TYPE;
_flow campaignlist.flow%TYPE;
isValid bool;
errors JSONB;
nameInvalid bool;
begin

select doc->>'name' into _name;
select doc->>'id' into _id;
select doc->>'campaign_id' into _campaign_id;
select doc->>'campaignfile_id' into _campaignfile_id;
select doc->>'flow' into _flow;

call LOGJSONADD( concat('CampaignlistUpdateJSON1 name=',_name,',_id=',_id,' campaign_id=', _campaign_id, ' campaignfile_id=', _campaignfile_id), doc);

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;



isValid := true;
nameInvalid := false;

errors := '{}';
_js:='{}';

if exists (select 1 from campaignlist where campaignlist.id=_id) then
  call LOGADD('CampaignlistUpdateJSON1.1 record exists');
else
  call LOGADD('CampaignlistUpdateJSON1.1 record does not exist');
  isValid:=false;
  select jsetstr(errors, 'error', 'Unknown error (record not found)') into errors;
end if;


if _name is null or length(_name)=0 then
  isValid:=false;
  select jsetstr(errors, 'name', 'Name is required') into errors;
end if;

if not nameInvalid and exists (select 1 from campaignlist where name=_name and campaign_id=_campaign_id) then
  isValid:=false;
   select jsetstr(errors, 'name', 'Name must be unique') into errors;
end if;


call LOGJSONADD( concat('CampaignlistUpdateJSON2 isValid=',isValid), errors );

if isValid then
  update campaignlist set name=_name, campaign_id=_campaign_id, campaignfile_id=_campaignfile_id, flow=_flow where campaignlist.id=_id;
  select SuccessWithoutPayloadJSON() into _js;
else
  select ErrsJSON( errors ) into _js;
end if;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestCampaignlistUpdateJSON');

create or replace procedure TestCampaignlistUpdateJSON()
as $$
declare
_js JSONB;
_res JSONB;
begin

call TRACE('1TestCampaignlistUpdateJSON1');

_js:='{ "name": "testq", "id": 1 }';

_js:='{ "name": "testcampaignlist", "campaign_id": 1 }';

select jsetjson(_js, 'flow', '{"start": 1}') into _js;

select CampaignlistUpdateJSON(_js, testsession2()) into _js;

call TRACE( concat('TestCampaignlistUpdateJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignlistUpdateJSON();

