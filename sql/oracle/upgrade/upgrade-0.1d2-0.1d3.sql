-- ./contrib/packages/events/sql/oracle/events-activities-package-create.sql    
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

-- ./contrib/packages/events/sql/oracle/events-events-package-create.sql    
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



-- ./contrib/packages/events/sql/oracle/events-orders-package-create.sql
--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was originally written by Bryan Che and Philip Greenspun
--
-- GNU GPL v2
--

-- Order Package

create or replace package events_order
as
   function new (
      order_id				in events_orders.order_id%TYPE default null,
      user_id				in users.user_id%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_orders.order_id%TYPE;

   procedure del (
      order_id				in events_orders.order_id%TYPE
   );

end events_order;
/
show errors;



create or replace package body events_order
as
   function new (
      order_id				in events_orders.order_id%TYPE default null,
      user_id				in users.user_id%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_orders.order_id%TYPE
   is
      v_order_id                     acs_objects.object_id%TYPE;
   begin
      v_order_id:= acs_object.new (
                                      object_id => order_id,
                                      object_type => 'events_order',
                                      creation_date => creation_date,
                                      creation_user => creation_user,
                                      creation_ip => creation_ip,
                                      context_id => context_id
                                      );

      insert into events_orders
      (order_id, user_id)
      values
      (v_order_id, user_id);

      return v_order_id;
   end new;

   procedure del (
      order_id				in events_orders.order_id%TYPE
   )
   is 
   begin
      acs_object.delete(del.order_id);
   end del;

end events_order;
/
show errors;


-- ./contrib/packages/events/sql/oracle/events-registrations-package-create.sql

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

-- The Registration Package

create or replace package events_registration
as
   function new (
      reg_id				in events_registrations.reg_id%TYPE default null,
      event_id				in events_events.event_id%TYPE,
      user_id				in users.user_id%TYPE,
      reg_state				in events_registrations.reg_state%TYPE,
      comments                          in events_registrations.comments%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_registrations.reg_id%TYPE;

   procedure del (
      reg_id				in events_registrations.reg_id%TYPE
   );

end events_registration;
/
show errors;



create or replace package body events_registration
as
   function new (
      reg_id				in events_registrations.reg_id%TYPE default null,
      event_id				in events_events.event_id%TYPE,
      user_id				in users.user_id%TYPE,
      reg_state				in events_registrations.reg_state%TYPE,
      comments                          in events_registrations.comments%TYPE,
      creation_date                     in acs_objects.creation_date%TYPE default sysdate,
      creation_user                     in acs_objects.creation_user%TYPE,
      creation_ip                       in acs_objects.creation_ip%TYPE,
      context_id                        in acs_objects.context_id%TYPE default null
   ) return events_registrations.reg_id%TYPE
   is
      v_reg_id                     acs_objects.object_id%TYPE;
   begin
      v_reg_id:= acs_object.new (
                                      object_id => reg_id,
                                      object_type => 'events_registration',
                                      creation_date => creation_date,
                                      creation_user => creation_user,
                                      creation_ip => creation_ip,
                                      context_id => context_id
                                      );

      insert into events_registrations
      (reg_id, event_id, user_id, reg_state, comments)
      values
      (v_reg_id, event_id, user_id, reg_state, comments);

      return v_reg_id;
   end new;

   procedure del (
      reg_id				in events_registrations.reg_id%TYPE
   )
   is 
   begin
      acs_object.delete(reg_id);
   end del;

end events_registration;
/
show errors;

-- ./contrib/packages/events/sql/oracle/events-venues-package-create.sql

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


-- The Venue Package

create or replace package events_venue
as
   function new (
      venue_id				in events_venues.venue_id%TYPE default null,
      package_id                        in events_venues.package_id%TYPE default null,
      venue_name			in events_venues.venue_name%TYPE,
      address1				in events_venues.address1%TYPE default null,
      address2				in events_venues.address2%TYPE default null,
      city				in events_venues.city%TYPE,
      usps_abbrev			in events_venues.usps_abbrev%TYPE default null,
      postal_code			in events_venues.postal_code%TYPE default null,
      time_zone				in events_venues.time_zone%TYPE default null,
      iso				in events_venues.iso%TYPE default null,
      phone_number			in events_venues.phone_number%TYPE default null,
      fax_number			in events_venues.fax_number%TYPE default null,
      email				in events_venues.email%TYPE default null,
      needs_reserve_p			in events_venues.needs_reserve_p%TYPE default 'f',
      max_people			in events_venues.max_people%TYPE default null,
      description			in events_venues.description%TYPE default null
   ) return events_venues.venue_id%TYPE;

   procedure del (
      venue_id                       in events_venues.venue_id%TYPE
   );

end events_venue;
/
show errors;

create or replace package body events_venue
as
   function new (
      venue_id				in events_venues.venue_id%TYPE default null,
      package_id                        in events_venues.package_id%TYPE default null,
      venue_name			in events_venues.venue_name%TYPE,
      address1				in events_venues.address1%TYPE default null,
      address2				in events_venues.address2%TYPE default null,
      city				in events_venues.city%TYPE,
      usps_abbrev			in events_venues.usps_abbrev%TYPE default null,
      postal_code			in events_venues.postal_code%TYPE default null,
      time_zone				in events_venues.time_zone%TYPE default null,
      iso				in events_venues.iso%TYPE default null,
      phone_number			in events_venues.phone_number%TYPE default null,
      fax_number			in events_venues.fax_number%TYPE default null,
      email				in events_venues.email%TYPE default null,
      needs_reserve_p			in events_venues.needs_reserve_p%TYPE default 'f',
      max_people			in events_venues.max_people%TYPE default null,
      description			in events_venues.description%TYPE default null
   ) return events_venues.venue_id%TYPE
   is
      v_venue_id                      events_venues.venue_id%TYPE;
   begin

      insert into events_venues
      (venue_id, venue_name, address1, address2, city, usps_abbrev, postal_code, iso, phone_number,
      time_zone, fax_number, email, needs_reserve_p, max_people, description, package_id)
      values
      (venue_id, venue_name, address1, address2, city, usps_abbrev, postal_code, iso, phone_number,
      time_zone, fax_number, email, needs_reserve_p, max_people, description, package_id);

      return v_venue_id;
   end new;

   procedure del (
      venue_id			in events_venues.venue_id%TYPE
   )
   is 
   begin
      delete from events_venues where venue_id = del.venue_id;   
      acs_object.delete(del.venue_id);
   end del;

end events_venue;
/
show errors;


