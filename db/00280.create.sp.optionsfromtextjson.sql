call TRACE('create SP OPTIONSFROMTEXTJSON');


create or replace function OPTIONSFROMTEXTJSON(str varchar(2000) )
returns JSONB
as $$
declare
k varchar(200);
v varchar(2000);
listdelim varchar(10);
kvdelim varchar(10);
_js JSONB;
begin

listdelim = ';';
kvdelim = '=';

_js:='{}';


for k,v in (select  kvleft(s) k, kvright(s) v from splitstring(str, listdelim) s)
loop

  if length(k)>0 and length(v)>0 then
    _js := jsetstr(_js, k, v);
  end if;

end loop;

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestOPTIONSFROMTEXTJSON');

create or replace procedure  TestOPTIONSFROMTEXTJSON()
as $$
declare
_js JSONB;
begin

delete from log;

--select  kvleft(s) k, kvright(s) v from splitstring('name = Joh, lastname=Smith', ',') s

select * from OPTIONSFROMTEXTJSON('name = Joh') into _js;

call TRACE( concat('TestOPTIONSFROMTEXTJSON ', _js) );


select * from OPTIONSFROMTEXTJSON('name = Joh; lastname=Smith') into _js;

call TRACE( concat('TestOPTIONSFROMTEXTJSON ', _js) );



end
$$
language plpgsql;


call TestOPTIONSFROMTEXTJSON();
