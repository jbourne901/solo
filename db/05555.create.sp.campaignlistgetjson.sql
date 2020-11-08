call TRACE('create SP CampaignlistGetJSON');

create or replace function CampaignlistGetJSON(id campaignlist.id%TYPE, session TYPE_SESSIONPARAM)
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


select row_to_json(q) into _js from (select c.name,c.id,c.campaign_id,c.campaignfile_id, 
                                       (select q.name from campaign q where q.id=c.campaign_id) campaign, 
                                       (select t.name from campaignfile t where t.id=c.campaignfile_id) file 
                                     from campaignlist c where c.id=_id
                                    ) q;

if _js is null then
   select UnknownErrJSON() into _js;
else
   select SuccessWithPayloadJSON(_js) into _js;
end if;

return _js;

end
$$
language plpgsql;





call TRACE('create SP TestCampaignlistGetJSON');

create or replace procedure TestCampaignlistGetJSON()
as $$
declare
_js JSONB;
begin

select * from CampaignlistGetJSON(1, testsession2()) into _js;

call TRACE( concat ('TestCampaignlistGetJSON ', _js) );

end
$$
language plpgsql;

call TestCampaignlistGetJSON();


