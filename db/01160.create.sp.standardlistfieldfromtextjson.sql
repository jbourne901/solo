call TRACE('create SP StandardListFieldFromTextJSON');

drop function if exists StandardListFieldFromTextJSON;

create or replace function StandardListFieldFromTextJSON(str text, delim varchar(10), globaloptions JSONB default null)
returns JSON
as $$
declare
_js JSONB;
_name varchar(50);
_label text;
_optionstr varchar(2000);
begin

select split_part(str, delim,1) into _name;
select split_part(str, delim,2) into _label;
select split_part(str, delim,3) into _optionstr;


_js:='{}';
_js:=jsetstr(_js, 'name',_name);
_js:=jsetstr(_js, 'label',_label);

_js := SafeMergeOptionsJSON( globaloptions, _name, _js);
_js := SafeMergeStrOptionsJSON( _optionstr, _js);

return _js;

end
$$
language plpgsql;






call TRACE('create SP TestStandardListFieldFromTextJSON');

drop procedure if exists TestStandardListFieldFromTextJSON;

create or replace procedure  TestStandardListFieldFromTextJSON()
as $$
declare
_js JSONB;
begin


select * from StandardListFieldFromTextJSON('name/Name', '/') into _js;


call TRACE( concat('TestStandardListFieldFromTextJSON ', _js) );

end
$$
language plpgsql;


call TestStandardListFieldFromTextJSON();
