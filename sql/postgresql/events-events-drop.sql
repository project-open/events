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

create function inline_0 ()
returns integer as '
declare
        event_rec                    record;
begin
        for event_rec in select event_id from events_events
	loop
                delete from events_events where event_id = event_rec.event_id;
                delete from acs_events where event_id = event_rec.event_id;
		delete from acs_objects where object_id = event_rec.event_id;
        end loop;
        return 0;
end;' language 'plpgsql';

select inline_0();
drop function inline_0();

drop table events_events;

select acs_object_type__drop_type(
           'events_event',
           't'
        );
