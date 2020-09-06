call TRACE('create SP AgentScenarioCRUDJSON');

create or replace procedure AgentScenarioCRUDJSON()
as $$
declare
_js JSONB;
begin

call CRUDFunctionsCreate('agentscenario');


end
$$
language plpgsql;


call AgentScenarioCRUDJSON();
