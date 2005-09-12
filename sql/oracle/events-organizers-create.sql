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

-- Organizer roles for activities and events

create sequence events_org_roles_seq start with 1;
create table events_organizer_roles (
       role_id			integer 
				constraint evnts_org_roles_role_id_pk 
				primary key,
       role			varchar(200) 
				constraint evnts_org_roles_role_nn
				not null,
       responsibilities		clob,
       -- is this a role that we want event registrants to see?
       public_role_p		char(1) default 'f' 
				constraint evnts_org_roles_public_role_p
				check (public_role_p in ('t', 'f')),
       package_id		integer
				constraint evnts_org_roles_pkg_id_fk
				references apm_packages
				on delete cascade
);

create table events_org_role_activity_map (
       role_id			integer
				constraint evnts_org_role_am_role_id_fk
				references events_organizer_roles,
       activity_id		integer
				constraint evnts_org_role_act_id_fk
				references events_activities
);

create table events_org_role_event_map (
       role_id			integer
				constraint evnts_org_role_em_role_id_fk
				references events_organizer_roles,
       event_id			integer
				constraint evnts_org_role_evnt_id_fk
				references events_events
);

create table events_organizers_map (
       user_id			   constraint evnt_org_map_user_id_nn
				   not null
				   constraint evnt_org_map_user_id_fk
				   references users,
       role_id			   integer 
				   constraint evnt_org_map_role_id_nn
				   not null 
				   constraint evnt_org_map_role_id_fk
				   references events_organizer_roles,
       event_id			   integer
				   constraint evnt_org_map_evnt_id_nn
				   not null
				   constraint evnt_org_map_evnt_id_fk
				   references events_events,
       constraint events_org_map_pk primary key (user_id, role_id, event_id)
);

-- create a view to see event organizer roles and the people in those roles
create or replace view events_organizers 
as
select eor.*, eom.user_id, eorem.event_id
  from events_organizer_roles eor, 
       events_org_role_event_map eorem,
       events_organizers_map eom
 where eor.role_id = eorem.role_id
   and eorem.role_id = eom.role_id(+);




