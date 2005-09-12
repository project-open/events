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
--
-- Venue Object Types
--


create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''events_venue'',		-- object_type
	''Venue'',			-- pretty_name
	''Venues'',			-- pretty_plural
	''acs_object'',			-- supertype
	''events_venues'',		-- table_name
	''venue_id'',			-- id_column
	''events_venue'',		-- package_name
	''f'',				-- abstract_p
	null,				-- type_extensions_table
	''events_venue.name''   	-- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();








create function inline_1 ()
returns integer as '
begin
    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',		-- object_type
	  ''venue_name'',		-- attribute_name
	  ''string'',			-- datatype
	  ''Name'',			-- pretty_name
	  ''Names'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''address1'',				-- attribute_name
	  ''string'',				-- datatype
	  ''Address 1'',			-- pretty_name
	  ''Address 1'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''address2'',				-- attribute_name
	  ''string'',				-- datatype
	  ''Address 2'',			-- pretty_name
	  ''Address 2'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''city'',				-- attribute_name
	  ''string'',				-- datatype
	  ''City'',			-- pretty_name
	  ''Cities'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''usps_abbrev'',			-- attribute_name
	  ''string'',				-- datatype
	  ''USPS Abbreviation'',		-- pretty_name
	  ''USPS Abbreviations'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''postal_code'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Postal Code'',			-- pretty_name
	  ''Postal Codes'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''iso'',				-- attribute_name
	  ''string'',				-- datatype
	  ''Country Code'',			-- pretty_name
	  ''Country Codes'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''description'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Description'',			-- pretty_name
	  ''Descriptions'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''fax_number'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Fax Number'',			-- pretty_name
	  ''Fax Numbers'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''phone_number'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Phone Number'',			-- pretty_name
	  ''Phone Numbers'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''email'',				-- attribute_name
	  ''string'',				-- datatype
	  ''Email Address'',			-- pretty_name
	  ''Email Addresses'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_venue'',			-- object_type
	  ''max_people'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Maximum Number of People'',		-- pretty_name
	  ''Maximum Number of People'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();














--
--
-- Should usps_abbrev be - referneces us_states(abbrev)?
--
--
-- where the events occur
create table events_venues (
       venue_id		  integer 
			  constraint events_venues_pk
			  primary key,
       venue_name	  varchar(200) not null,
       address1		  varchar(100),
       address2		  varchar(100),
       city		  varchar(100),
       usps_abbrev	  char(2),
       postal_code	  varchar(20),
       iso		  char(2) default 'US' references countries,
       time_zone	  integer references timezones(tz_id),
       -- some contact info for this venue
       phone_number	  varchar(30),
       fax_number	  varchar(30),
       email		  varchar(100),
       needs_reserve_p	  boolean default 'f',
       max_people	  integer,
       description	  varchar(4000),
       package_id	  integer
			  constraint evnts_venues_pkg_id_fk
			  references apm_packages
			  on delete cascade
);