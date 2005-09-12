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

drop table events_activities;
delete from acs_objects where object_type = 'events_activity';

declare begin
    acs_object_type.drop_type (object_type => 'events_activity' );
end;
/
show errors;
