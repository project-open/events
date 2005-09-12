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

declare
  cursor v_event_ids is
  select event_id from events_events;
begin
  for row in v_event_ids loop
    delete from events_events where event_id = row.event_id;
    delete from acs_events where event_id = row.event_id;
    delete from acs_objects where object_id = row.event_id;
  end loop;
end;
/
show errors;

drop table events_events;

declare begin
	acs_object_type.drop_type (object_type => 'events_event');
end;
/
show errors;

