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

declare
begin

    acs_object_type.create_type(
        object_type => 'events_venue',
        pretty_name => 'Venue',
        pretty_plural => 'Venues',
        supertype => 'acs_object',
        table_name => 'events_venues',
        id_column => 'venue_id',
	package_name => 'events_venue'
    );

end;
/
show errors;

declare 
        attr_id acs_attributes.attribute_id%TYPE; 
begin
        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'venue_name', 
                datatype        =>      'string',
                pretty_name     =>      'Name', 
                pretty_plural   =>      'Names'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'address1', 
                datatype        =>      'string',
                pretty_name     =>      'Address 1', 
                pretty_plural   =>      'Address 1'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'address2', 
                datatype        =>      'string',
                pretty_name     =>      'Address 2', 
                pretty_plural   =>      'Address 2'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'city', 
                datatype        =>      'string',
                pretty_name     =>      'City', 
                pretty_plural   =>      'Cities' 
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'usps_abbrev', 
                datatype        =>      'string', 
                pretty_name     =>      'USPS Abbreviation', 
                pretty_plural   =>      'USPS Abbreviations' 
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'postal_code', 
                datatype        =>      'string',
                pretty_name     =>      'Postal Code', 
                pretty_plural   =>      'Postal Codes'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'iso', 
                datatype        =>      'string',
                pretty_name     =>      'Country Code', 
                pretty_plural   =>      'Country Codes'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'description', 
                datatype        =>      'string', 
                pretty_name     =>      'Description', 
                pretty_plural   =>      'Descriptions' 
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'fax_number', 
                datatype        =>      'string',
                pretty_name     =>      'Fax Number', 
                pretty_plural   =>      'Fax Numbers'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'phone_number', 
                datatype        =>      'string',
                pretty_name     =>      'Phone Number', 
                pretty_plural   =>      'Phone Numbers' 
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'email', 
                datatype        =>      'string',
                pretty_name     =>      'Email Address', 
                pretty_plural   =>      'Email Addresses'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_venue', 
                attribute_name  =>      'max_people', 
                datatype        =>      'string',
                pretty_name     =>      'Maximum Number of People', 
                pretty_plural   =>      'Maximum Number of People'
        );

end;
/
show errors;


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
       time_zone	  number references timezones(tz_id),
       -- some contact info for this venue
       phone_number	  varchar(30),
       fax_number	  varchar(30),
       email		  varchar(100),
       needs_reserve_p	  char(1) default 'f' check (needs_reserve_p in ('t', 'f')),
       max_people	  integer,
       description	  varchar(4000),
       package_id	  integer
			  constraint evnts_venues_pkg_id_fk
			  references apm_packages
			  on delete cascade
);