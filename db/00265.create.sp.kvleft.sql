call TRACE('create SP KVLEFT');

create or replace function KVLEFT(str varchar(2000), delim varchar(10) = '=')
returns varchar
as $$
declare
res varchar(200);
begin

if str not like concat('%',delim,'%') then
  return null;
end if;

select t[1] from (select string_to_array(str, delim) t) t into res;

return trim( res );

end
$$
language plpgsql;






call TRACE('create SP TestKVLEFT');

create or replace procedure  TestKVLEFT()
as $$
declare
_js varchar(2000);
begin


select * from KVLEFT('name = Joh') into _js;

call TRACE( concat('TestKVLEFT ', _js) );


select * from KVLEFT('= Joh') into _js;

call TRACE( concat('TestKVLEFT ', _js) );



end
$$
language plpgsql;


call TestKVLEFT();
