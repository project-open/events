<?xml version="1.0"?>
<queryset>

	<fullquery  name="events::venue::edit.update_events_venues">
		<querytext>
		update events_venues
		   set venue_name = :venue_name,
		       address1 = :address1,
		       address2 = :address2,
		       city = :city,
		       usps_abbrev = :usps_abbrev,
		       postal_code = :postal_code,
		       iso = :iso,
		       time_zone = :time_zone,
		       phone_number = :phone_number,
		       fax_number = :fax_number,
		       email = :email,
		       needs_reserve_p = :needs_reserve_p,
		       max_people = :max_people,
		       description = :description
		 where venue_id = :venue_id
		</querytext>
	</fullquery>

	<fullquery  name="events::venue::get.select_venue_info">
		<querytext>
		select venue_name, address1, address2, city, usps_abbrev, postal_code, iso, 
                       time_zone, phone_number, fax_number, email, 
                       needs_reserve_p, max_people, description
		  from events_venues
		 where venue_id = :venue_id
		</querytext>
	</fullquery>

	<fullquery  name="events::venue::exists_p.exists_p_select">
		<querytext>
		select 1 from events_venues where venue_id = :venue_id
		</querytext>
	</fullquery>

	<fullquery name="events::venue::venues_get_options.select_venues">
		<querytext>
		select venue_name, venue_id
		  from events_venues
		</querytext>
	</fullquery>

	<fullquery name="events::venue::make_child_of.check_venue_one">
		<querytext>
		select venue_id from events_venues where venue_id=:parent_id and package_id=:package_id
		</querytext>
	</fullquery>

	<fullquery name="events::venue::make_child_of.check_venue_two">
		<querytext>
		select venue_id from events_venues where venue_id=:child_id and package_id=:package_id
		</querytext>
	</fullquery>

    	<fullquery name="events::venue::make_child_of.insert_relationship">
        	<querytext>
		insert into events_venues_venues_map (parent_venue_id, child_venue_id, package_id) values (:parent_id, :child_id, :package_id)
        	</querytext>
    	</fullquery>

	<fullquery name="events::venue::right_of_p.select_starting_point">
		<querytext>
		select right_venue_id from events_venues_connecting_map where right_venue_id=:right_id and left_venue_id=:left_id and package_id=:package_id
		</querytext>
	</fullquery>

	<fullquery name="events::venue::connect.check_venue_one">
		<querytext>
		select venue_id from events_venues where venue_id=:left_id and package_id=:package_id
		</querytext>
	</fullquery>

	<fullquery name="events::venue::connect.check_venue_two">
		<querytext>
		select venue_id from events_venues where venue_id=:right_id and package_id=:package_id
		</querytext>
	</fullquery>

    	<fullquery name="events::venue::connect.insert_relationship">
        	<querytext>
		insert into events_venues_connecting_map (left_venue_id, right_venue_id, package_id) values (:left_id, :right_id, :package_id)
        	</querytext>
    	</fullquery>

	<fullquery name="events::venue::disconnect.check_venue_one">
		<querytext>
		select venue_id from events_venues where venue_id=:left_id and package_id=:package_id
		</querytext>
	</fullquery>

	<fullquery name="events::venue::disconnect.check_venue_two">
		<querytext>
		select venue_id from events_venues where venue_id=:right_id and package_id=:package_id
		</querytext>
	</fullquery>

    	<fullquery name="events::venue::disconnect.delete_relationship">
        	<querytext>
		delete from events_venues_connecting_map where package_id=:package_id and ((left_venue_id=:left_id and right_venue_id=:right_id) or (right_venue_id=:left_id and left_venue_id=:right_id))
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::connecting.select_venues">
        	<querytext>
		select venue_id as this_venue_id, venue_name from events_venues where package_id=:package_id and venue_id<>:venue_id order by venue_name, venue_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::parents_or_children.select_parents">
        	<querytext>
		select parent_venue_id as venue_1, child_venue_id as venue_2 from events_venues_venues_map where child_venue_id=$venue_id and package_id=$package_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::parents_or_children.select_children">
        	<querytext>
		select child_venue_id as venue_1, parent_venue_id as venue_2 from events_venues_venues_map where parent_venue_id=$venue_id and package_id=$package_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::venues_get_connecting_options.select_venues">
        	<querytext>
		select venue_id, venue_name from events_venues where package_id=:package_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::venues_get_hierarchy_options.select_venues">
        	<querytext>
		select venue_id, venue_name from events_venues where venue_id<>:this_venue_id and package_id=:package_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::dechildize.delete_child">
        	<querytext>
		delete from events_venues_venues_map where child_venue_id=:child_id and (parent_venue_id=:parent_id or parent_venue_id in ([events::venue::all_parents_or_children -venue_id $parent_id -parent_p "f" -sql_p "t"])) and package_id=:package_id
        	</querytext>
    	</fullquery>

    	<fullquery name="events::venue::connected.select_connecting">
        	<querytext>
		select connected_venue_id, events_venues.venue_name as connected_venue_name from events_venues_conn_used_map, events_venues where events_venues_conn_used_map.event_id=:event_id and events_venues_conn_used_map.venue_id=:venue_id and events_venues_conn_used_map.package_id=:package_id and events_venues_conn_used_map.connected_venue_id=events_venues.venue_id
        	</querytext>
    	</fullquery>

	<fullquery name="events::venue::connecting_max.select_parents">
	        <querytext>
	        select min(max_people) as min from events_venues where venue_id in ([events::venue::all_parents_or_children -venue_id $venue_id -parent_p "t" -sql_p "t"])
	        </querytext>
	</fullquery>

</queryset>