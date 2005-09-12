--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was originally written by Bryan Che and Phillip Greenspun
--
-- GNU GPL v2
--

-- Activity Object Type

declare
begin

    acs_object_type.create_type(
        object_type => 'events_activity',
        pretty_name => 'Event Activity',
        pretty_plural => 'Event Activities',
        supertype => 'acs_activity',
        table_name => 'events_activities',
        id_column => 'activity_id'
    );

end;
/
show errors;

-- create activity attributes
declare 
        attr_id acs_attributes.attribute_id%TYPE; 
begin

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_activity', 
                attribute_name  =>      'description', 
                datatype        =>      'string',
                pretty_name     =>      'Description', 
                pretty_plural   =>      'Descriptions'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_activity', 
                attribute_name  =>      'detail_url', 
                datatype        =>      'string',
                pretty_name     =>      'Detail URL', 
                pretty_plural   =>      'Detail URLs' 
        );
end;
/
show errors;

-- Each activity has the super_type of ACS_ACTIVITY
-- Table events_activities supplies additional information
create table events_activities (
	activity_id	integer
                        constraint events_activity_id_fk
                        references acs_activities
                        constraint events_activity_id_pk
                        primary key,
	-- FIXME: (from old package) activities are owned by user groups
	-- use map function in acs_activity? why?
	--
	-- keep track of event package instances in this table
        package_id      integer
                        constraint events_activities_pkg_id_fk
                        references apm_packages(package_id)
                        on delete cascade,
	default_price   number default 0 not null,
	currency	char(3) default 'USD',
        -- Is this activity occurring? If not, we can't assign
        -- any new events to it.
        available_p	char(1) default 't' check (available_p in ('t', 'f')),
        deleted_p	char(1) default 'f' check (deleted_p in ('t', 'f')),
	-- URL for more details
        detail_url 	varchar(256),
	default_contact_user_id integer references users
);

comment on table events_activities is '
	Table events_activities supplies additional information for events_activities type.
';
