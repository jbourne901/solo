call TRACE('create SP StandardEditFieldFromTextJSON');

drop function if exists StandardEditFieldFromTextJSON;

create or replace function StandardEditFieldFromTextJSON(str text, globaloptions JSONB default null)
returns JSON
as $$
declare
_js JSONB;
delim varchar(10);
_name epagefield.name%TYPE;
_label epagefield.label%TYPE;
_type epagefield.type%TYPE;
_tab epagefield.tab%TYPE;
_query epagefield.query%TYPE;
_stroptions0 varchar(200);
begin

delim := '/';

select split_part(str, delim,1) into _name;
select split_part(str, delim,2) into _label;
select coalesce(split_part(str, delim,3), '{}') into _stroptions0;

-- 'username/Username'
-- 'password/Password/type=password'
-- 'name/Name/tab=general'
-- 'userrole/User Role/query=UserRoleList'
-- 'flow/Flow/query=FlowTemplateList, tab='Flow'


_js:='{}';

select StandardEditFieldJSON(_name, _label ) into _js;

_js := SafeMergeStrOptionsJSON(_stroptions0, _js);
_js := SafeMergeOptionsJSON(globaloptions, _name, _js);

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestStandardEditFieldFromTextJSON');

drop procedure if exists TestStandardEditFieldFromTextJSON;

create or replace procedure  TestStandardEditFieldFromTextJSON()
as $$
declare
_js JSONB;
begin


select * from StandardEditFieldFromTextJSON('name/Name') into _js;
call TRACE( concat('TestStandardEditFieldFromTextJSON ', _js) );

select * from StandardEditFieldFromTextJSON('password/Password/type=password; tab=tab40') into _js;
call TRACE( concat('TestStandardEditFieldFromTextJSON ', _js) );

select * from StandardEditFieldFromTextJSON('flow/Flow') into _js;
call TRACE( concat('TestStandardEditFieldFromTextJSON ', _js) );


end
$$
language plpgsql;


call TestStandardEditFieldFromTextJSON();
