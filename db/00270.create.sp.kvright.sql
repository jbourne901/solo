call TRACE('create SP KVRIGHT');

create or replace function KVRIGHT(str varchar(2000), delim varchar(10) = '=')
returns varchar
as $$
declare
res varchar(200);
begin

if str not like concat('%',delim,'%') then
  return null;
end if;

select t[2] from (select string_to_array(str, delim) t) t into res;

return trim( res );

end
$$
language plpgsql;






call TRACE('create SP TestKVRIGHT');

create or replace procedure  TestKVRIGHT()
as $$
declare
_js varchar(2000);
begin


select * from KVRIGHT('name = Joh') into _js;

call TRACE( concat('TestKVRIGHT ', _js) );


select * from KVRIGHT('= Joh') into _js;

call TRACE( concat('TestKVRIGHT ', _js) );



end
$$
language plpgsql;


call TestKVRIGHT();
