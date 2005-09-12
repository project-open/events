<?xml version="1.0"?>
<queryset>

   <fullquery name="select_venue">
	<querytext>
	select venue_name, address1, address2, city, usps_abbrev, postal_code, iso, 
                       time_zone, phone_number, fax_number, email, 
                       needs_reserve_p, max_people, description
		  from events_venues
		 where venue_id = :venue_id
   	</querytext>
   </fullquery>

</queryset>
