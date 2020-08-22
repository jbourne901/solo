call TRACE('create SP MenuListJSON');

create or replace function MenuListJSON(name menu.name%TYPE, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_name alias for name;
_id menu.id%TYPE;
begin

select ValidateSessionJSON(session) into _js;

if _js->>'result' = 'Error' then
  return _js;
end if;


select id into _id from menu where menu.name=_name;
select json_agg(q) into _js from ( select b.*, (select json_agg(cc) from (select c.* from menu c where c.parent_id=b.id order by c.ordno) cc) items from menu b where b.parent_id=_id ) q;


if _js is null then
  _js = '[]';
end if;

select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestMenuListJSON');

create or replace procedure  TestMenuListJSON()
as $$
declare
_js JSONB;
begin

select * from MenuListJSON('topmenu', testsession2()) into _js;

call TRACE( concat('TestMenuListJSON ', _js) );

end
$$
language plpgsql;


call TestMenuListJSON();


