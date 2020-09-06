call TRACE('create SP TopMenuAdd');

drop procedure if exists TopMenuAdd;

create procedure TopMenuAdd()
as $$
declare
   comma varchar(1);
   items text;
   _js JSONB;
begin

  comma:=',';

  delete from menu where name='top';

 items := concat( 'agentdesktop|/agentdesktop|Agent Desktop|Escritorio del Agente||', comma,
                   'management|/management|Management|Administración||', comma,
                   'qa|/qa|QA|QA||', comma,
                   'analytics|/analytics|Analytics|Analítica||', comma,
                   'settings|/settings|Settings|Ajustes||', comma,
                   'system|/system|System|Sistema||', comma,
                   'profile|/profile|Profile|Perfil||', comma,
                   'help|/help|Help and Support|Ayuda y Soporte||', comma
                 );
                   
  select MenuListAddJSON('top', items, testsession2()) into _js;
  
  items := concat( 'agentview|/management/epage-agentview|Agents|Agentes||', comma,
                   'queueview|/management/epage-queueview|Queues|Colas||', comma,
                   'campaigview|/management/epage-campaignview|Campaigns|Campañas||', comma,
                   'callview|/management/epage-callview|Calls|Llamadas||', comma,
                   'wfm|/management/epage-list|WFM|WFM||', comma,
                   'realtime|/management/epage-realtime|Realtime|Vistas in Tiempo Real||', comma,
                   'historical|/management/epage-historical|Historical Reporting|Informes Historicos||', comma
                  );

  select MenuListAddJSON('management', items, testsession2()) into _js;

  items := concat( 'billing|/profile/epage-billing|Billing|Facturación||', comma,
                   'cdr|/profile/epage-cdr|CDRs|CDRs||', comma,
                   'payment|/profile/epage-payment|Payments|Pagos||', comma
                  );

  select MenuListAddJSON('profile', items, testsession2()) into _js;


  items := concat( 'user|/settings/epage-user|Users|Usarios||', comma,
                   'group|/settings/epage-group|Groups|Gruppas||', comma,
                   'queue|/settings/epage-queue|Queues|Colas||', comma,
                   'trunk|/settings/epage-trunk|Trunks|Troncos||', comma,
                   'routing|/settings/epage-routing|Routing|Enrutamiento||', comma,
                   'campaign|/settings/epage-campaign|Campaigns|Campañas||', comma,
                   'list|/settings/epage-list|Lists|Listas||', comma,
                   'crm|/settings/epage-crm|CRM|CRM||', comma,
                   'agentscenario|/settings/epage-agentscenario|Agent Scenarios|Escenarios del Agente||', comma,
                   'recordedmessage|/settings/epage-recordedmessage|Recorded Messages|Mensajes Grabados||', comma,
                   'resource|/settings/epage-resource|Resources|Recursos||', comma,
                   'localization|/settings/epage-localization|Localization|Localización||', comma
                  );

  select MenuListAddJSON('settings', items, testsession2()) into _js;


  items := concat( 'sysresource|/system/epage-sysresources|System Resources|Recursos del Sistema||', comma,
                   'sysperf|/system/epage-sysperformance|System Performance|Redimento del Sistema||', comma
                 );

  select MenuListAddJSON('system', items, testsession2()) into _js;


end
$$
language plpgsql;

call TRACE('call TopMenuAdd');

call TopMenuAdd();

