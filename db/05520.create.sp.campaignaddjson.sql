call TRACE('create SP CampaignAddJSON');

create or replace function CampaignAddJSON(doc JSONB, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_name campaign.name%TYPE;
isValid bool;
nameInvalid bool;
errors JSONB;
_id campaign.id%TYPE;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select doc->>'name' into _name;

call LOGJSONADD( concat('CampaignAddJSON1 name=',_name), doc);

isValid := true;
nameInvalid := false;

errors := '{}';
_js:='{}';

if _name is null or length(_name)=0 then
  isValid:=false;
  select jsetstr(errors, 'name', 'Name is required') into errors;
end if;

if not nameInvalid and exists (select 1 from campaign where name=_name) then
  isValid:=false;
   select jsetstr(errors, 'name', 'Name must be unique') into errors;
end if;


call LOGJSONADD( concat('CampaignAddJSON2 isValid=',isValid), errors );

if isValid then
  insert into campaign(name)
  select _name;
  select campaign.id into _id from campaign where campaign.name=_name;
  select jsetint('{}', 'id', _id) into _js;
  select SuccessWithPayloadJSON(_js) into _js;
else
  select ErrsJSON(errors) into _js;
end if;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestCampaignAddJSON');

create or replace procedure TestCampaignAddJSON()
as $$
declare
_js JSONB;
begin

call TRACE('1TestCampaignAddJSON1');

_js:='{ "name": "testcampaign" }';

select CampaignAddJSON(_js, testsession2()) into _js;

call TRACE( concat('TestCampaignAddJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignAddJSON();

