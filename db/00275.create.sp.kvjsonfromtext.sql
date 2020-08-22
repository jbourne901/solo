call TRACE('create SP KVJSONFROMTEXT');

create or replace function KVJSONFROMTEXT(str varchar(2000), delim varchar(10) = '=')
returns JSONB
as $$
declare
k varchar(200);
v varchar(2000);
_js JSONB;
begin

_js:='{}';
if str not like concat('%',delim,'%') then
  return _js;
end if;

k := KVLEFT(str, delim);
v := KVRIGHT(str, delim);

if length(k)>0 and length(v)>0 then
  _js:=jsetstr(_js, k, v);
end if;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestKVJSONFROMTEXT');

create or replace procedure  TestKVJSONFROMTEXT()
as $$
declare
_js JSONB;
begin


select * from KVJSONFROMTEXT('name = Joh') into _js;

call TRACE( concat('TestKVJSONFROMTEXT ', _js) );


select * from KVJSONFROMTEXT('= Joh') into _js;

call TRACE( concat('TestKVJSONFROMTEXT ', _js) );



end
$$
language plpgsql;


call TestKVJSONFROMTEXT();
