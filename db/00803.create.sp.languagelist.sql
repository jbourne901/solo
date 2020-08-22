call TRACE('create SP LanguageListJSON');

create or replace function LanguageListJSON(session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select json_agg(q) into _js from (select * from language) q;

if _js is null then
  _js = '[]';
end if;

select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestLanguageListJSON');

create or replace procedure  TestLanguageListJSON()
as $$
declare
_js JSONB;
begin

select * from LanguageListJSON(testsession2()) into _js;

call TRACE( concat('TestLanguageListJSON ', _js) );

end
$$
language plpgsql;


call TestLanguageListJSON();

