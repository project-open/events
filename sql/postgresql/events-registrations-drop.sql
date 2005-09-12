--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was orinally written by Bryan Che and Phillip Greenspun
--
-- GNU GPL v2
--
delete from acs_objects where object_type = 'events_registration';
select acs_object_type__drop_type(
           'events_registration',
           't'
        );


--drop view events_orders_states;
--drop view  events_reg_not_canceled;
--drop view  events_reg_canceled;
--drop view  events_reg_shipped;
DROP FUNCTION event_ship_date_trigger_proc ();
DROP trigger event_ship_date_trigger on events_registrations;
drop table events_registrations;



