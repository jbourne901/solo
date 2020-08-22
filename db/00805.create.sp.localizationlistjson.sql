call TRACE('create SP LocalizationListJSON');

create or replace function LocalizationListJSON(session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select json_agg(q) into _js from (select id, grp, key, language, value from localization) q;

if _js is null then
  _js = '[]';
end if;

select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestLocalizationListJSON');

create or replace procedure  TestLocalizationListJSON()
as $$
declare
_js JSONB;
begin

select * from LocalizationListJSON(testsession2()) into _js;

call TRACE( concat('TestLocalizationListJSON ', _js) );

end
$$
language plpgsql;


call TestLocalizationListJSON();
