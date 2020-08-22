call TRACE('create SP MenuAddJSON');

drop function if exists MenuAddJSON;

create or replace function MenuAddJSON(doc JSONB, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
_name menu.name%TYPE;
_url menu.url%TYPE;
_icon menu.icon%TYPE;
_parent menu.name%TYPE;
_parent_id menu.parent_id%TYPE;
_ordno menu.ordno%TYPE;
_id menu.id%TYPE;
_epage_id epage.id%TYPE;
begin

call LOGJSONADD( 'MenuAddJSON1 doc=', doc );

select doc->>'name' into _name;
select doc->>'url' into _url;
select doc->>'icon' into _icon;
select doc->>'parent' into _parent;
select doc->>'epage_id' into _epage_id;

call LOGJSONADD( concat('MenuAddJSON1 name=',_name,',epage_id=',_epage_id,',url=',_url,',parent=',_parent, ',icon=', _icon), doc);

delete from menu where name=_name;

select m.id into _parent_id from menu m where m.name=_parent;

select max(ordno) into _ordno from menu where parent_id=_parent_id;
if _ordno is null then
   _ordno=1;
else 
   _ordno = _ordno+1;
end if;


insert into menu(name,url,icon,parent_id,ordno, epage_id)
select _name, _url, _icon, _parent_id, _ordno, _epage_id;

select id into _id from menu where name=_name;

select jsetint('{}', 'id',  _id) into _js;
select SuccessWithPayloadJSON(_js) into _js;

return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestMenuAddJSON');

create or replace procedure TestMenuAddJSON()
as $$
declare
_js JSONB;
begin

call TRACE('TestMenuAddJSON1-->');

_js:='{ "name": "testmenu", "url": "/testmenu" }';
select MenuAddJSON(_js, testsession2()) into _js;

call TRACE( concat('--->TestMenuAddJSON1 ', _js) );


call TRACE('TestMenuAddJSON2-->');

_js:='{ "name": "testsubmenu", "url": "/testsubmenu","parent":"testmenu" }';
select MenuAddJSON(_js, testsession2()) into _js;

call TRACE( concat('--->TestMenuAddJSON1 ', _js) );




end
$$
language plpgsql;

call TestMenuAddJSON();
