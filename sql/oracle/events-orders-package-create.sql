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
