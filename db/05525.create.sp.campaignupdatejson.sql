call TRACE('create SP CampaignUpdateJSON');

create or replace function CampaignUpdateJSON(doc JSONB, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_name campaign.name%TYPE;
_id campaign.id%TYPE;
isValid bool;
errors JSONB;
nameInvalid bool;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select doc->>'name' into _name;
select doc->>'id' into _id;

call LOGJSONADD( concat('CampaignUpdateJSON1 name=',_name,',_id=',_id), doc);

isValid := true;
nameInvalid := false;

errors := '{}';
_js:='{}';

if exists (select 1 from campaign where campaign.id=_id) then
  call LOGADD('CampaignUpdateJSON1.1 record exists');
else
  call LOGADD('CampaignUpdateJSON1.1 record does not exist');
  isValid:=false;
  select jsetstr(errors, 'error', 'Unknown error (record not found)') into errors;
end if;


if _name is null or length(_name)=0 then
  isValid:=false;
  select jsetstr(errors, 'name', 'Name is required') into errors;
end if;

if not nameInvalid and exists (select 1 from campaign where name=_name) then
  isValid:=false;
   select jsetstr(errors, 'name', 'Name must be unique') into errors;
end if;


call LOGJSONADD( concat('CampaignUpdateJSON2 isValid=',isValid), errors );

if isValid then
  update campaign set name=_name where campaign.id=_id;
  select SuccessWithoutPayloadJSON() into _js;
else
  select ErrsJSON( errors ) into _js;
end if;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestCampaignUpdateJSON');

create or replace procedure TestCampaignUpdateJSON()
as $$
declare
_js JSONB;
_res JSONB;
begin

call TRACE('1TestCampaignUpdateJSON1');

_js:='{ "name": "testq", "id": 1 }';

select CampaignUpdateJSON(_js, testsession2()) into _js;

call TRACE( concat('TestCampaignUpdateJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignUpdateJSON();

