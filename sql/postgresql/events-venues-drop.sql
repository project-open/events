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

delete from acs_objects where object_type = 'events_venue';
select acs_object_type__drop_type(
           'events_venue',
           't'
        );

drop table events_venues;