call TRACE('create SP CampaignGetJSON');

create or replace function CampaignGetJSON(id campaign.id%TYPE, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_id alias for id;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select row_to_json(q) into _js from (select c.name,c.id, (select json_agg(q) from campaignlist q where q.campaign_id=c.id) lists from campaign c where c.id=_id) q;

if _js is null then
   select UnknownErrJSON() into _js;
else
   select SuccessWithPayloadJSON(_js) into _js;
end if;

return _js;

end
$$
language plpgsql;





call TRACE('create SP TestCampaignGetJSON');

create or replace procedure TestCampaignGetJSON()
as $$
declare
_js JSONB;
begin

select * from CampaignGetJSON(1, testsession2()) into _js;

call TRACE( concat ('TestCampaignGetJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignGetJSON();


