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

-- Activity Object Type

create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''events_activity'',		-- object_type
	''Event Activity'',		-- pretty_name
	''Event Activities'',		-- pretty_plural
	''acs_activity'',		-- supertype
	''events_activities'',		-- table_name
	''activity_id'',		-- id_column
	null,           		-- package_name
	''f'',				-- abstract_p
	null,				-- type_extensions_table
	''events_activity.name''	-- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();



create function inline_1 ()
returns integer as '
begin
    PERFORM acs_attribute__create_attribute (
	  ''events_activity'',	        	-- object_type
	  ''description'',	        	-- attribute_name
	  ''string'',		        	-- datatype
	  ''Description'',	        	-- pretty_name
	  ''Descriptions'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',            	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_activity'',			-- object_type
	  ''detail_url'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Detail URL'',			-- pretty_name
	  ''Detail URLs'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	                -- storage
	  ''f''					-- static_p
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();



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
	default_price   numeric default 0 not null,
	currency	char(3) default 'USD',
        -- Is this activity occurring? If not, we can't assign
        -- any new events to it.
        available_p	boolean default 't',
        deleted_p	boolean default 'f',
	-- URL for more details
        detail_url 	varchar(256),
	default_contact_user_id integer references users
);

comment on table events_activities is '
	Table events_activities supplies additional information for events_activities type.
';
