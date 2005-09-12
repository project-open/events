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

drop table events_activities;
delete from acs_objects where object_type = 'events_activity';

select acs_object_type__drop_type(
           'events_activity',
           't'
        );
