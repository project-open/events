--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was orinally written by Bryan Che and Philip Greenspun
--
-- GNU GPL v2
--


-- The Activity Package

select define_function_args('events_activity__new','activity_id,package_id,detail_url,default_contact_user_id,name,description,html_p;f,status_summary,object_type;events_activity,creation_date,creation_user,creation_ip,context_id');

create function events_activity__new (integer,integer,varchar,integer,varchar,varchar,boolean,varchar,varchar,timestamp,integer,varchar,integer)
returns integer as '
declare
      p_activity_id	          alias for $1;       -- default null	
      p_package_id                alias for $2; 
      p_detail_url	          alias for $3;       -- default null			
      p_default_contact_user_id   alias for $4; 
      p_name    	          alias for $5;       -- default null			
      p_description	          alias for $6;       -- default null	
      p_html_p		          alias for $7;       -- default ''f''
      p_status_summary	          alias for $8;       -- default null	
      p_object_type	          alias for $9;       -- default ''events_activity''	
      p_creation_date             alias for $10;      -- default now()				
      p_creation_user             alias for $11;      	
      p_creation_ip               alias for $12;      
      p_context_id                alias for $13;      -- default null	                
      v_activity_id                   integer;        
begin
      v_activity_id := acs_activity__new (
                                      p_activity_id,
				      p_name,
				      p_description,
				      p_html_p,
				      p_status_summary,
                                      p_object_type,
                                      p_creation_date,
                                      p_creation_user,
                                      p_creation_ip,
                                      coalesce(p_context_id, p_package_id)
                                      );

      insert into events_activities
      (activity_id, package_id, detail_url, default_contact_user_id)
      values
      (v_activity_id, p_package_id, p_detail_url, p_default_contact_user_id);


        return v_activity_id;

end;' language 'plpgsql';



select define_function_args('events_activity__name','activity_id');

create function events_activity__name(integer)
returns varchar as '
declare
    p_activity_id                      alias for $1;
begin
    return name from acs_activities where activity_id = p_activity_id;
end;
' language 'plpgsql';



select define_function_args('events_activity__delete','activity_id');

create function events_activity__delete (integer)
returns integer as '
declare
  p_activity_id				alias for $1;
  row RECORD;
begin
	FOR row IN
	    	select event_id as v_event_id from acs_events
		where activity_id = p_activity_id
	LOOP
		events_event__delete(v_event_id);
	END LOOP;
	delete from events_def_actvty_attr_map where activity_id = p_activity_id;
	delete from events_org_role_activity_map where activity_id = p_activity_id;
	delete from events_activities where activity_id = p_activity_id;

	raise NOTICE ''Deleting note...'';
	PERFORM acs_object__delete(p_activity_id);

	return 0;
end;' language 'plpgsql';





