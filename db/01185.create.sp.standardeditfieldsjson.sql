call TRACE('create SP StandardEditFieldsJSON');

drop function if exists StandardEditFieldsJSON;
create or replace function StandardEditFieldsJSON(fields varchar, globaloptions JSONB default null)
returns JSONB
as $$
declare
_js JSONB;
begin

_js:='{}';

select json_agg( StandardEditFieldFromTextJSON(splitstring, globaloptions) )from (select * from SplitString(fields, ',')) q into _js;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestStandardEditFieldsJSON');

create or replace procedure TestStandardEditFieldsJSON()
as $$
declare
_js JSONB;
begin


call TRACE('1TestStandardEditFieldsJSON1');


select * from StandardEditFieldsJSON('name/Name/tab=tab1; username/Username/tab=tab2; password/Password/type=password, password2/Confirm password/type=password') into _js;

call TRACE( concat( '1TestStandardEditFieldsJSON ', _js) );

end
$$
language plpgsql;

call TestStandardEditFieldsJSON();
