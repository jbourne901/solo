
call TRACE('create procedure EPageFillJSON');

create or replace procedure EPageFillJSON()
as $$
declare
_js JSONB;
begin

call TRACE(  'EPageFilJSON1 - start1' );


select * from StandardEPageAddJSON('user', 'Users', 'name/Name, username/Username',  'name/Name, username/Username, password/Password/type=password, password2/Confirm Password/type=password', testsession2() ) into _js;


call TRACE(  'EPageFilJSON1 - start2' );


select * from StandardEPageAddJSON('queue', 'Queues', 'name/Name', 'name/Name', testsession2() ) into _js;

call TRACE(  'EPageFilJSON1 - start3' );


select * from StandardEPageAddJSON('localization', 'Localization', 'grp/Resource, key/Key, language/Language, value/Value', 'grp/Resource, key/Key, language/Language, value/Value', testsession2() ) into _js;

call TRACE(  'EPageFilJSON1 - start4' );


select * from StandardEPageAddJSON('agentscenario', 'Agent Scenarios', 'name/Name', 'name/Name/tab=general, flow/Flow/type=flowchart; tab=flow; query=AgentScenarioTemplateList', testsession2(), '{"editpage": {"actions": { "all":{"location":"top"} } } }' ) into _js;



call TRACE( 'EPageFillJSON1 - end' );



end
$$
language plpgsql;

call EPageFillJSON();
                                 
