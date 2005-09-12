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
-- 
-- 
-- -- The Event Package
-- 

select define_function_args('events_event__new','event_id,venue_id,display_after,max_people,reg_deadline,available_p;t,deleted_p;f,reg_cancellable_p,reg_needs_approval_p,refreshments_note,av_note,additional_note,alternative_reg,activity_id');

create function events_event__new (integer,integer,varchar,integer,timestamp,boolean,boolean,boolean,boolean,integer,varchar,varchar,varchar,varchar,integer)
returns integer as '
declare
      p_event_id		alias for $1; 	      -- default null
      p_venue_id		alias for $2; 
      p_display_after		alias for $3;         -- default null
      p_max_people		alias for $4; 	      -- default null
      p_reg_deadline		alias for $5; 	
      p_available_p		alias for $6; 	      -- default ''t''
      p_deleted_p		alias for $7; 	      -- default ''f''
      p_reg_cancellable_p	alias for $8; 	
      p_reg_needs_approval_p	alias for $9;
      p_contact_user_id		alias for $10;  	
      p_refreshments_note	alias for $11;	      -- default null
      p_av_note			alias for $12;	      -- default null
      p_additional_note		alias for $13;	      -- null
      p_alternative_reg		alias for $14; 	      -- null
      p_activity_id		alias for $15; 	
      v_activity_attrs          record;
      v_activity_org_roles      record; 
begin


      insert into events_events
      (event_id, contact_user_id, venue_id, display_after, max_people, reg_deadline, available_p, deleted_p, reg_cancellable_p, reg_needs_approval_p, refreshments_note, av_note, additional_note, alternative_reg)
      values
      (p_event_id, p_contact_user_id, p_venue_id, p_display_after, p_max_people, p_reg_deadline::timestamp, p_available_p, p_deleted_p, p_reg_cancellable_p, p_reg_needs_approval_p, p_refreshments_note, p_av_note, p_additional_note, p_alternative_reg);

      for v_activity_attrs in select
                  attribute_id as v_attribute_id
                from events_def_actvty_attr_map edaam
                  where edaam.activity_id = p_activity_id
      LOOP
      -- copy over pointers to custom fields (registration attributes)
          insert into events_event_attr_map
	  (event_id, attribute_id)
	  values
	  (p_event_id, v_activity_attrs.v_attribute_id);
      end loop;



      for v_activity_org_roles in select
                  role_id as v_role_id
                from events_org_role_activity_map eoram
                  where eoram.activity_id = p_activity_id
      LOOP
      -- copy over pointers to custom fields (registration attributes)
          insert into events_org_role_event_map
	  (event_id, role_id)
	  values
	  (p_event_id, v_activity_org_roles.v_role_id);
      end loop;


  return p_event_id;

end;' language 'plpgsql';


select define_function_args('events_event__name','event_id');

create function events_event__name(integer)
returns varchar as '
declare
    p_event_id                      alias for $1;
begin
    return aa.name from acs_activities aa, acs_events ae where 
        aa.activity_id = ae.activity_id
    and ae.event_id = p_event_id;
end;
' language 'plpgsql';




select define_function_args('events_event__delete','event_id');

create function events_event__delete (integer)
returns integer as '
declare
  p_event_id				alias for $1;
begin
      delete from events_org_role_event_map where event_id = del.event_id;
      delete from events_event_attr_map where event_id = del.event_id;
      delete from events_events where event_id = del.event_id;

	raise NOTICE ''Deleting note...'';
	PERFORM acs_object__delete(p_event_id);

	return 0;

end;' language 'plpgsql';

