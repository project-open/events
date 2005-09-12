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


-- The Event Package

create or replace package events_event
as
   procedure new (
      event_id				in events_events.event_id%TYPE default null,
      venue_id				in events_venues.venue_id%TYPE,
      display_after			in events_events.display_after%TYPE default null,
      max_people			in events_events.max_people%TYPE default null,
      reg_deadline			in events_events.reg_deadline%TYPE,
      available_p			in events_events.available_p%TYPE default 't',
      deleted_p				in events_events.deleted_p%TYPE default 'f',
      reg_cancellable_p			in events_events.reg_cancellable_p%TYPE,
      reg_needs_approval_p		in events_events.reg_needs_approval_p%TYPE,
      contact_user_id			in events_events.contact_user_id%TYPE default null,
      refreshments_note			in events_events.refreshments_note%TYPE default null,
      av_note				in events_events.av_note%TYPE default null,
      additional_note			in events_events.additional_note%TYPE default null,
      alternative_reg			in events_events.alternative_reg%TYPE default null,
      activity_id			in acs_events.activity_id%TYPE
   );

--    function new (
--       event_id				in events_events.event_id%TYPE default null,
--       venue_id				in events_venues.venue_id%TYPE,
--       display_after			in events_events.display_after%TYPE default null,
--       max_people			in events_events.max_people%TYPE default null,
--       reg_deadline			in events_events.reg_deadline%TYPE,
--       available_p			in events_events.available_p%TYPE default 't',
--       deleted_p				in events_events.deleted_p%TYPE default 'f',
--       reg_cancellable_p			in events_events.reg_cancellable_p%TYPE,
--       reg_needs_approval_p		in events_events.reg_needs_approval_p%TYPE,
--       refreshments_note			in events_events.refreshments_note%TYPE default null,
--       av_note				in events_events.av_note%TYPE default null,
--       additional_note			in events_events.additional_note%TYPE default null,
--       alternative_reg			in events_events.alternative_reg%TYPE default null,
--       activity_id			in acs_events.activity_id%TYPE,
--       name				in acs_events.name%TYPE default null,
--       description			in acs_events.description%TYPE default null,
--       html_p			        in acs_events.html_p%TYPE default 'f',
--       status_summary                    in acs_events.status_summary%TYPE default null,
--       timespan_id                       in acs_events.timespan_id%TYPE,
--       recurrence_id                     in acs_events.recurrence_id%TYPE default null,
--       object_type                       in acs_objects.object_type%TYPE default 'events_event',
--       creation_date                     in acs_objects.creation_date%TYPE default sysdate,
--       creation_user                     in acs_objects.creation_user%TYPE,
--       creation_ip                       in acs_objects.creation_ip%TYPE,
--       context_id                        in acs_objects.context_id%TYPE default null
--    ) return events_events.event_id%TYPE;

   procedure del (
      event_id                       in events_events.event_id%TYPE
   );

end events_event;
/
show errors;

create or replace package body events_event
as
   procedure new (
      event_id				in events_events.event_id%TYPE default null,
      venue_id				in events_venues.venue_id%TYPE,
      display_after			in events_events.display_after%TYPE default null,
      max_people			in events_events.max_people%TYPE default null,
      reg_deadline			in events_events.reg_deadline%TYPE,
      available_p			in events_events.available_p%TYPE default 't',
      deleted_p				in events_events.deleted_p%TYPE default 'f',
      reg_cancellable_p			in events_events.reg_cancellable_p%TYPE,
      reg_needs_approval_p		in events_events.reg_needs_approval_p%TYPE,
      contact_user_id			in events_events.contact_user_id%TYPE default null,
      refreshments_note			in events_events.refreshments_note%TYPE default null,
      av_note				in events_events.av_note%TYPE default null,
      additional_note			in events_events.additional_note%TYPE default null,
      alternative_reg			in events_events.alternative_reg%TYPE default null,
      activity_id			in acs_events.activity_id%TYPE
   )
   is
      cursor v_activity_attrs is
      select attribute_id 
        from events_def_actvty_attr_map edaam
       where edaam.activity_id = new.activity_id;
      cursor v_activity_org_roles is
      select role_id
        from events_org_role_activity_map eoram
       where eoram.activity_id = new.activity_id;
   begin

      insert into events_events
      (event_id, contact_user_id, venue_id, display_after, max_people, reg_deadline, available_p,
      deleted_p, reg_cancellable_p, reg_needs_approval_p, refreshments_note, av_note, 
      additional_note, alternative_reg)
      values
      (event_id, contact_user_id, venue_id, display_after, max_people, reg_deadline, available_p,
      deleted_p, reg_cancellable_p, reg_needs_approval_p, refreshments_note, av_note, 
      additional_note, alternative_reg);

      -- copy over pointers to custom fields (registration attributes)
      for row in v_activity_attrs loop
        insert into events_event_attr_map
	(event_id, attribute_id)
	values
	(event_id, row.attribute_id);
      end loop;

      for row in v_activity_org_roles loop
        insert into events_org_role_event_map
	(event_id, role_id)
	values
	(event_id, row.role_id);
      end loop;
   end new;

--    function new (
--       event_id				in events_events.event_id%TYPE default null,
--       venue_id				in events_venues.venue_id%TYPE,
--       display_after			in events_events.display_after%TYPE default null,
--       max_people			in events_events.max_people%TYPE default null,
--       reg_deadline			in events_events.reg_deadline%TYPE,
--       available_p			in events_events.available_p%TYPE default 't',
--       deleted_p				in events_events.deleted_p%TYPE default 'f',
--       reg_cancellable_p			in events_events.reg_cancellable_p%TYPE,
--       reg_needs_approval_p		in events_events.reg_needs_approval_p%TYPE,
--       refreshments_note			in events_events.refreshments_note%TYPE default null,
--       av_note				in events_events.av_note%TYPE default null,
--       additional_note			in events_events.additional_note%TYPE default null,
--       alternative_reg			in events_events.alternative_reg%TYPE default null,
--       activity_id			in acs_events.activity_id%TYPE,
--       name				in acs_events.name%TYPE default null,
--       description			in acs_events.description%TYPE default null,
--       html_p			        in acs_events.html_p%TYPE default 'f',
--       status_summary                    in acs_events.status_summary%TYPE default null,
--       timespan_id                       in acs_events.timespan_id%TYPE,
--       recurrence_id                     in acs_events.recurrence_id%TYPE default null,
--       object_type                       in acs_objects.object_type%TYPE default 'events_event',
--       creation_date                     in acs_objects.creation_date%TYPE default sysdate,
--       creation_user                     in acs_objects.creation_user%TYPE,
--       creation_ip                       in acs_objects.creation_ip%TYPE,
--       context_id                        in acs_objects.context_id%TYPE default null
--    ) return events_events.event_id%TYPE
--    is
--       v_event_id                        events_events.event_id%TYPE;
--       cursor v_activity_attrs is
--       select attribute_id 
--         from events_def_actvty_attr_map edaam
--        where edaam.activity_id = new.activity_id;
--       cursor v_activity_org_roles is
--       select role_id
--         from events_org_role_activity_map eoram
--        where eoram.activity_id = new.activity_id;
--    begin
--       v_event_id := acs_event.new (
--                                       event_id => event_id,
-- 				      name => name,
-- 				      description => description,
-- 				      html_p => html_p,
-- 				      status_summary => status_summary,
-- 				      timespan_id => timespan_id,
-- 				      activity_id => activity_id,
-- 				      recurrence_id => recurrence_id,
--                                       object_type => object_type,
--                                       creation_date => creation_date,
--                                       creation_user => creation_user,
--                                       creation_ip => creation_ip,
--                                       context_id => context_id
--                                  );

--       insert into events_events
--       (event_id, venue_id, display_after, max_people, reg_deadline, available_p,
--       deleted_p, reg_cancellable_p, reg_needs_approval_p, refreshments_note, av_note, 
--       additional_note, alternative_reg)
--       values
--       (v_event_id, venue_id, display_after, max_people, reg_deadline, available_p,
--       deleted_p, reg_cancellable_p, reg_needs_approval_p, refreshments_note, av_note, 
--       additional_note, alternative_reg);

--       -- copy over pointers to custom fields (registration attributes)
--       for row in v_activity_attrs loop
--         insert into events_event_attr_map
-- 	(event_id, attribute_id)
-- 	values
-- 	(v_event_id, row.attribute_id);
--       end loop;

--       for row in v_activity_org_roles loop
--         insert into events_org_role_event_map
-- 	(event_id, role_id)
-- 	values
-- 	(v_event_id, row.role_id);
--       end loop;

--       return v_event_id;
--    end new;

   procedure del (
      event_id			in events_events.event_id%TYPE
   )
   is 
   begin
      delete from events_org_role_event_map where event_id = del.event_id;
      delete from events_event_attr_map where event_id = del.event_id;
      delete from events_events where event_id = del.event_id;
      acs_object.delete(event_id);
   end del;

end events_event;
/
show errors;

