call TRACE(' create procedure SafeMergeStrOptionsJSON');

drop function if exists SafeMergeStrOptionsJSON;
create or replace function SafeMergeStrOptionsJSON( stroptions varchar(200),  destination_object JSONB)
returns JSONB
as $$
declare
_options JSONB;
begin

stroptions:=trim(stroptions);
if stroptions is null or length(stroptions) = 0 then
  return destination_object;
end if;

_options := OPTIONSFROMTEXTJSON(stroptions);

if _options is not null then
    destination_object := destination_object || _options;
end if;

return destination_object;

end
$$
language plpgsql;



call TRACE('create SP TestSafeMergeStrOptionsJSON');

create or replace procedure  TestSafeMergeStrOptionsJSON()
as $$
declare
_js JSONB;
begin

select * from SafeMergeStrOptionsJSON( 'type=flow; tab=flowchart; query=TemplateListJSON', '{"name": "flow", "label": "Flow"}' ) into _js;

call TRACE( concat('TestSafeMergeStrOptionsJSON ', _js) );

end
$$
language plpgsql;


call TestSafeMergeStrOptionsJSON();
