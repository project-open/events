--
-- The Events Package
--
-- @author Brad Duell (bduell@ncacasi.org)
-- @version $Id$
--
-- GNU GPL v2
--

-- allow venue hierarchy
create table events_venues_venues_map (
       	parent_venue_id		integer not null references events_venues(venue_id),
	child_venue_id		integer not null references events_venues(venue_id),
	package_id		integer
				constraint events_v_v_pkg_id_fk
				references apm_packages(package_id)
				on delete cascade,
	primary key (parent_venue_id, child_venue_id, package_id)

);

-- allow venue connections
create table events_venues_connecting_map (
       	left_venue_id		integer not null references events_venues(venue_id),
	right_venue_id		integer not null references events_venues(venue_id),
	package_id		integer
				constraint events_v_c_pkg_id_fk
				references apm_packages(package_id)
				on delete cascade,
	primary key (left_venue_id, right_venue_id, package_id)	

);

-- use-case mapping between venue connections
create table events_venues_conn_used_map (
	event_id 		integer not null references events_events,
	venue_id 		integer not null references events_venues,
	connected_venue_id 	integer not null references events_venues(venue_id),
	package_id 		integer
				constraint events_v_cu_pkg_id_fk
				references apm_packages(package_id)
			  	on delete cascade,
	primary key (event_id, venue_id, connected_venue_id, package_id)
);