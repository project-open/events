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

delete from acs_objects where object_type = 'events_order';
select acs_object_type__drop_type(
           'events_order',
           't'
        );


drop table events_orders;
