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
	parent_venue_id integer not null,
	child_venue_id integer not null,
	package_id integer
	constraint events_v_v_pkg_id_fk
	references apm_packages
	on delete cascade,
	constraint events_v_v_pk
	primary key(parent_venue_id, child_venue_id, package_id),
	constraint events_v_v_pv_id_fk foreign key(parent_venue_id)
	references events_venues(venue_id),
	constraint events_v_v_cv_id_fk foreign key(child_venue_id)
	references events_venues(venue_id));

-- allow venue connections
create table events_venues_connecting_map (
	left_venue_id integer not null,
	right_venue_id integer not null,
	package_id integer
	constraint events_v_c_pkg_id_fk
	references apm_packages
	on delete cascade,
	constraint events_v_c_pk
	primary key(left_venue_id, right_venue_id, package_id),
	constraint events_v_c_lv_id_fk foreign key(left_venue_id)
	references events_venues(venue_id),
	constraint events_v_c_rv_id_fk foreign key(right_venue_id)
	references events_venues(venue_id));

-- use-case mapping between venue connections
create table events_venues_conn_used_map (
	event_id integer not null,
	venue_id integer not null,
	connected_venue_id integer not null,
	package_id integer
	constraint events_v_cu_pkg_id_fk
	references apm_packages
	on delete cascade,
	constraint events_v_cu_pk
	primary key(event_id, venue_id, connected_venue_id, package_id),
	constraint events_v_cu_v_id_fk foreign key(venue_id)
	references events_venues(venue_id),
	constraint events_v_cu_cv_id_fk foreign key(connected_venue_id)
	references events_venues(venue_id),
	constraint events_v_cu_e_id_fk foreign key(event_id)
	references events_events(event_id));