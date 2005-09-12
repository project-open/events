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

--drop view events_orders_states;
--drop view  events_reg_not_canceled;
--drop view  events_reg_canceled;
--drop view  events_reg_shipped;
drop table events_registrations;

delete from acs_objects where object_type = 'events_registration';

declare
begin

    acs_object_type.drop_type (
        object_type => 'events_registration'
    );
end;
/
show errors;
