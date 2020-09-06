call TRACE('create SP MenuListAddJSON');

drop function if exists MenuListAddJSON;

create or replace function MenuListAddJSON(parent menu.name%TYPE, items text, session TYPE_SESSIONPARAM)
returns JSONB
as $$
declare
_js JSONB;
 _cur refcursor;
_s text;
_name menu.name%TYPE;
_url menu.url%TYPE;
_icon menu.icon%TYPE;
_en localization.value%TYPE;
_es localization.value%TYPE;
_parent_id menu.parent_id%TYPE;
_top menu.name%TYPE;
_epage_id epage.id%TYPE;

d varchar(1);
begin

call LOGADD( concat('MenuListAddJSON1 parent=', parent, ' items=', items ) );

   select ValidateSessionJSON(session) into _js;

   if _js->>'result' = 'Error' then
      call LOGADD( concat('MenuListAddJSON1 error - invalid session ') );
      return _js;
   end if;


   if not exists (select 1 from menu where name=parent) then
     _js:='{}';
     _js:=jsetstr(_js, 'name',parent);
     select MenuAddJSON(_js, session) into _js;
   end if;

   select m.id into _parent_id from menu m where m.name=parent;
   select coalesce(m3.name, m2.name, m1.name, m.name, parent) into _top from menu m left join menu m1  on m.parent_id=m1.id left join menu m2 on m1.parent_id=m2.id left join menu m3 on m2.parent_id=m3.id where m.name=parent;

   d:='|';

   open _cur for select * from splitstring(items, ',');
   loop
      fetch _cur into _s;
      exit when not found;

      select split_part(_s,d,1) into _name;
      select split_part(_s,d,2) into _url;
      select split_part(_s,d,3) into _en;
      select split_part(_s,d,4) into _es;
      select split_part(_s,d,5) into _icon;


      _js := '{}';      
      _js:=jsetstr(_js, 'name',_name);
      if length(_url)>0 then
         _js:=jsetstr(_js, 'url',_url);
      end if;
      if _parent_id is not null then
        _js:=jsetstr(_js, 'parent',parent);
      end if;
      if length(_icon)>0 then
         _js:=jsetstr(_js, 'icon',_icon);
      end if;

      call LOGJSONADD( concat('MenuListAddJSON1 s=',_s,' _name=',_name, ' _en=', _en, ' _es=', _es, ' _js=', _js), _js );

      if length(_name)>0 then
 
         if _url like '%epage%' then
           select e.id into _epage_id from epage e where e.name=_name;
         end if;
         if _epage_id is not null then
            _js:=jsetint(_js, 'epage_id',_epage_id);
         end if;

         select MenuAddJSON(_js, session) into _js;

         if length(_en) > 0 then
            _js:='{"language": "en"}';
            _js:=jsetstr(_js,'grp',concat('menu_', _top));
            _js:=jsetstr(_js,'key',_name);
            _js:=jsetstr(_js,'value',_en);
            call LOGJSONADD( concat('MenuListAddJSON2 js en localization='), _js); 
            select LocalizationAddJSON(_js, session) into _js;
         end if;
         if length(_es) > 0 then
            _js:='{"language": "es"}';
            _js:=jsetstr(_js,'grp',concat('menu_', _top));
            _js:=jsetstr(_js,'key',_name);
            _js:=jsetstr(_js,'value',_es);

            call LOGJSONADD( concat('MenuListAddJSON2 js es localization='), _js);

            select LocalizationAddJSON(_js, session) into _js;
         end if;

      end if;
   end loop;
  
   close _cur;


   select jsetint('{}', 'id',  _parent_id) into _js;
   select SuccessWithPayloadJSON(_js) into _js;

   return _js;

end
$$
language plpgsql;


call TRACE('create procedure TestMenuListAddJSON');

create or replace procedure TestMenuListAddJSON()
as $$
declare
_js JSONB;
_items text;
begin

call TRACE('TestMenuListAddJSON1-->');

delete from menu where name='testmenu';

_items:=concat('testsubmenu1|/testsubmenu1|TestSubMenu1|TestoSubmenu1||', ',',
               'testsubmenu2|/testsubmenu2|TestSubMenu2|TestoSubmenu2||', ',',
               'testsubmenu3|/testsubmenu3|TestSubMenu3|TestoSubmenu3||'
              );

select MenuListAddJSON('testmenu', _items, testsession2()) into _js;

call TRACE( concat('--->TestMenuListAddJSON1 ', _js) );


delete from menu where name='testmenu';


end
$$
language plpgsql;

call TestMenuListAddJSON();
