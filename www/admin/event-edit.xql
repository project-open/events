<?xml version="1.0"?>
<queryset>

    <fullquery name="event_exists">
	<querytext>
	select 1
	  from events_events
	 where event_id = :event_id
        </querytext>
    </fullquery>

    <fullquery name="select_email">
	<querytext>
	 select email from parties where party_id=:user_id
	</querytext>
    </fullquery>

    <fullquery name="select_contact_email">
	<querytext>
	select email as contact_email from parties where party_id=:contact_user_id
	</querytext>
    </fullquery>

    <fullquery name="contact_update">
	<querytext>
	update ec_products set email_on_purchase_list=:email, url='$activity_info(detail_url)',no_shipping_avail_p='t', active_p='t' where product_id=:product_id
	</querytext>
    </fullquery>

    <fullquery name="mapping_remove">
	<querytext>
	delete from ec_category_product_map where product_id=:product_id
	</querytext>
    </fullquery>

    <fullquery name="delete_connecting">
	<querytext>
	delete from events_venues_conn_used_map where event_id=:event_id and package_id=[ad_conn package_id]
	</querytext>
    </fullquery>

    <fullquery name="insert_connecting">
	<querytext>
	insert into events_venues_conn_used_map values (:event_id, :venue_id, [lindex $event_connecting $i], [ad_conn package_id])
	</querytext>
    </fullquery>

    <fullquery name="select_connecting">
	<querytext>
	select connected_venue_id from events_venues_conn_used_map where event_id=:event_id and venue_id=$event_info(venue_id) and package_id=[ad_conn package_id] and connected_venue_id=:venue_id
	</querytext>
    </fullquery>

    <fullquery name="valid_venue">
	<querytext>
	select venue_id from events_venues where venue_id=:venue_id and $connecting_venue_id in ([events::venue::connecting -venue_id $venue_id -package_id [ad_conn package_id] -sql_p "t"])
	</querytext>
    </fullquery>

</queryset>
