call TRACE('create SP StandardEditFieldJSON');

create or replace function StandardEditFieldJSON(name epagefield.name%TYPE, label epagefield.label%TYPE, options JSONB = '{}')
returns JSONB
as $$
declare
_js JSONB;
_type epagefield.type%TYPE;
_query epagefield.query%TYPE;
_tab epagefield.tab%TYPE;
begin


_type := coalesce(options->>'type', 'text');
_tab := coalesce(options->>'tab', '');
_query := coalesce(options->>'query', '');


_js:='{}';

_js := jsetstr(_js, 'name', name);
_js := jsetstr(_js, 'label', label);

_js := jsetstr(_js, 'tab', _tab);
_js := jsetstr(_js, 'query', _query);
_js:=jsetstr(_js, 'type', _type);



return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestStandardEditFieldJSON');

create or replace procedure TestStandardEditFieldJSON()
as $$
declare
_js JSONB;
begin


call TRACE('1TestStandardEditFieldJSON1');


select * from StandardEditFieldJSON('username', 'Username') into _js;

call TRACE( concat( '1TestStandardEditFieldJSON ', _js) );

select * from StandardEditFieldJSON('password', 'Password', '{"type": "password"}') into _js;

call TRACE( concat( '1TestStandardEditFieldJSON ', _js) );


select * from StandardEditFieldJSON('password', 'Password', '{"type": "password", "tab": "tab40", "query": "templateListJSON" }') into _js;

call TRACE( concat( '1TestStandardEditFieldJSON ', _js) );


end
$$
language plpgsql;

call TestStandardEditFieldJSON();
