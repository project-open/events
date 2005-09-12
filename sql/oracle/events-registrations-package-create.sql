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
