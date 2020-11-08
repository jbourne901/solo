call TRACE('create SP CampaignListJSON');

create or replace function CampaignListJSON( session TYPE_SESSIONPARAM, filter JSONB=null)
returns JSONB
as $$
declare
_js JSONB;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select json_agg(q) into _js from (select name,id from campaign) q;

if _js is null then
  _js = '[]';
end if;

select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestCampaignListJSON');

create or replace procedure  TestCampaignListJSON()
as $$
declare
_js JSONB;
begin

select * from CampaignListJSON(testsession2()) into _js;

call TRACE( concat('TestCampaignListJSON ', _js) );

end
$$
language plpgsql;


call TestCampaignListJSON();
