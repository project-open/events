--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net), Matthew Geddert (geddert@yahoo.com)
-- @version $Id$
--
-- This package was orinally written by Bryan Che and Philip Greenspun
--
-- GNU GPL v2
--


-- The Venue Package

select define_function_args('events_venue__new','venue_id,package_id,venue_name,address1,address2,city,usps_abbrev,postal_code,time_zone,iso,phone_number,fax_number,email,needs_reserve_p;f,max_people,description');

create function events_venue__new (integer,integer,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,varchar,varchar,varchar,boolean,integer,varchar)
returns integer as '
declare
      p_venue_id	   alias for $1;       -- default null	
      p_package_id	   alias for $2;       
      p_venue_name	   alias for $3;				
      p_address1	   alias for $4;       -- default null			
      p_address2	   alias for $5;       -- default null	
      p_city		   alias for $6;
      p_usps_abbrev        alias for $7;       -- default null
      p_postal_code        alias for $8;       -- default null
      p_time_zone          alias for $9;       -- default null
      p_iso                alias for $10;      -- default null
      p_phone_number	   alias for $11;       -- default null	
      p_fax_number	   alias for $12;       -- default null	
      p_email		   alias for $13;       -- default null 
      p_needs_reserve_p	   alias for $14;      -- default ''f''	
      p_max_people	   alias for $15;      -- default null	
      p_description	   alias for $16;      -- default null			
begin

        insert into events_venues
          (venue_id, venue_name, address1, address2, city, phone_number, fax_number, email, needs_reserve_p, max_people, description, usps_abbrev, postal_code, time_zone, iso, package_id)
        values
          (p_venue_id, p_venue_name, p_address1, p_address2, p_city, p_phone_number, p_fax_number, p_email, p_needs_reserve_p, p_max_people, p_description, p_usps_abbrev, p_postal_code, p_time_zone, p_iso, p_package_id);

        return p_venue_id;

end;' language 'plpgsql';


select define_function_args('events_venue__name','venue_id');

create function events_venue__name(integer)
returns varchar as '
declare
    p_venue_id                      alias for $1;
begin
    return venue_name from events_venues where venue_id = p_venue_id;
end;
' language 'plpgsql';



select define_function_args('events_venue__delete','venue_id');

create function events_venue__delete (integer)
returns integer as '
declare
  p_venue_id				alias for $1;
begin

	delete from events_venues where venue_id = p_venue_id;

	raise NOTICE ''Deleting events_venue...'';
	PERFORM acs_object__delete(p_venue_id);

	return 0;

end;' language 'plpgsql';
