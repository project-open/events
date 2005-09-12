--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was orinally written by Bryan Che and Philip Greenspun
--
-- GNU GPL v2
--


-- The Venue Package

create or replace package events_venue
as
   function new (
      venue_id				in events_venues.venue_id%TYPE default null,
      package_id                        in events_venues.package_id%TYPE default null,
      venue_name			in events_venues.venue_name%TYPE,
      address1				in events_venues.address1%TYPE default null,
      address2				in events_venues.address2%TYPE default null,
      city				in events_venues.city%TYPE,
      usps_abbrev			in events_venues.usps_abbrev%TYPE default null,
      postal_code			in events_venues.postal_code%TYPE default null,
      time_zone				in events_venues.time_zone%TYPE default null,
      iso				in events_venues.iso%TYPE default null,
      phone_number			in events_venues.phone_number%TYPE default null,
      fax_number			in events_venues.fax_number%TYPE default null,
      email				in events_venues.email%TYPE default null,
      needs_reserve_p			in events_venues.needs_reserve_p%TYPE default 'f',
      max_people			in events_venues.max_people%TYPE default null,
      description			in events_venues.description%TYPE default null
   ) return events_venues.venue_id%TYPE;

   procedure del (
      venue_id                       in events_venues.venue_id%TYPE
   );

end events_venue;
/
show errors;

create or replace package body events_venue
as
   function new (
      venue_id				in events_venues.venue_id%TYPE default null,
      package_id                        in events_venues.package_id%TYPE default null,
      venue_name			in events_venues.venue_name%TYPE,
      address1				in events_venues.address1%TYPE default null,
      address2				in events_venues.address2%TYPE default null,
      city				in events_venues.city%TYPE,
      usps_abbrev			in events_venues.usps_abbrev%TYPE default null,
      postal_code			in events_venues.postal_code%TYPE default null,
      time_zone				in events_venues.time_zone%TYPE default null,
      iso				in events_venues.iso%TYPE default null,
      phone_number			in events_venues.phone_number%TYPE default null,
      fax_number			in events_venues.fax_number%TYPE default null,
      email				in events_venues.email%TYPE default null,
      needs_reserve_p			in events_venues.needs_reserve_p%TYPE default 'f',
      max_people			in events_venues.max_people%TYPE default null,
      description			in events_venues.description%TYPE default null
   ) return events_venues.venue_id%TYPE
   is
      v_venue_id                      events_venues.venue_id%TYPE;
   begin

      insert into events_venues
      (venue_id, venue_name, address1, address2, city, usps_abbrev, postal_code, iso, phone_number,
      time_zone, fax_number, email, needs_reserve_p, max_people, description, package_id)
      values
      (venue_id, venue_name, address1, address2, city, usps_abbrev, postal_code, iso, phone_number,
      time_zone, fax_number, email, needs_reserve_p, max_people, description, package_id);

      return v_venue_id;
   end new;

   procedure del (
      venue_id			in events_venues.venue_id%TYPE
   )
   is 
   begin
      delete from events_venues where venue_id = del.venue_id;   
      acs_object.delete(del.venue_id);
   end del;

end events_venue;
/
show errors;
