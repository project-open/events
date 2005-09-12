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

create or replace package events_activity
as
   function new (
      activity_id			in events_activities.activity_id%TYPE default null,
      package_id			in events_activities.package_id%TYPE,
      detail_url			in events_activities.detail_url%TYPE default null,
      default_contact_user_id           in events_activities.default_contact_user_id%TYPE default null,
      name				in acs_activities.name%TYPE default null,
      description			in acs_activities.description%TYPE default null,
      html_p				in acs_activities.html_p%TYPE default 'f',
      status_summary			in acs_activities.status_summary%TYPE default null,
      object_type			in acs_object_types.object_type%TYPE default 'events_activity',
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_activities.activity_id%TYPE;

   procedure del (
      activity_id                       in events_activities.activity_id%TYPE
   );

end events_activity;
/
show errors;



create or replace package body events_activity
as
   function new (
      activity_id			in events_activities.activity_id%TYPE default null,
      package_id			in events_activities.package_id%TYPE,
      detail_url			in events_activities.detail_url%TYPE default null,
      default_contact_user_id           in events_activities.default_contact_user_id%TYPE default null,
      name				in acs_activities.name%TYPE default null,
      description			in acs_activities.description%TYPE default null,
      html_p				in acs_activities.html_p%TYPE default 'f',
      status_summary			in acs_activities.status_summary%TYPE default null,
      object_type			in acs_object_types.object_type%TYPE default 'events_activity',
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_activities.activity_id%TYPE
   is
      v_activity_id                     events_activities.activity_id%TYPE;
   begin
      v_activity_id:= acs_activity.new (
                                      activity_id => activity_id,
				      name => name,
				      description => description,
				      html_p => html_p,
				      status_summary => status_summary,
                                      object_type => object_type,
                                      creation_date => creation_date,
                                      creation_user => creation_user,
                                      creation_ip => creation_ip,
                                      context_id => context_id
                                      );

      insert into events_activities
      (activity_id, package_id, detail_url, default_contact_user_id)
      values
      (v_activity_id, package_id, detail_url, default_contact_user_id);

      return v_activity_id;
   end new;

   procedure del (
      activity_id			in events_activities.activity_id%TYPE
   )
   is 
      cursor v_activity_events is
      select event_id from acs_events
       where activity_id = del.activity_id;
   begin
      -- find and delete event instances
      for row in v_activity_events loop
	  events_event.del(row.event_id);
      end loop;
      delete from events_def_actvty_attr_map where activity_id = del.activity_id;
      delete from events_org_role_activity_map where activity_id = del.activity_id;
      delete from events_activities where activity_id = del.activity_id;
      acs_object.delete(activity_id);
   end del;

end events_activity;
/
show errors;
