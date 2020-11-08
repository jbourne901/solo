call TRACE('create SP CampaignListListJSON');

create or replace function CampaignListListJSON( session TYPE_SESSIONPARAM, filter JSONB=null )
returns JSONB
as $$
declare
_js JSONB;
_campaign_id campaign.id%TYPE;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;

select filter->>'campaign_id' into _campaign_id;

call LOGJSONADD( concat('CampaignListListJSON1 campaign_id=',_campaign_id), filter);


select json_agg(q) into _js from (select name,id from campaignlist c where (c.campaign_id = _campaign_id or _campaign_id is null) ) q;

if _js is null then
  _js = '[]';
end if;

select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestCampaignListListJSON');

create or replace procedure  TestCampaignListListJSON()
as $$
declare
_js JSONB;
begin

select * from CampaignListListJSON(testsession2(), '{"campaign_id": 1}') into _js;

call TRACE( concat('TestCampaignListListJSON ', _js) );

end
$$
language plpgsql;


call TestCampaignListListJSON();
