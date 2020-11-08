call TRACE('create SP CampaignDeleteJSON');

create or replace function CampaignDeleteJSON(id campaign.id%TYPE, session TYPE_SESSIONPARAM)
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


_js:='{}';

delete from campaign where campaign.id=_id;

select * from  SuccessWithoutPayloadJSON() into _js;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestCampaignDeleteJSON');

create or replace procedure TestCampaignDeleteJSON()
as $$
declare
_js JSONB;
begin

call TRACE('1TestCampaignDeleteJSON1');

select * from CampaignDeleteJSON(7777, testsession2()) into _js;

call TRACE( concat('TestCampaignDeleteJSON ', _js) );


end
$$
language plpgsql;

call TestCampaignDeleteJSON();

