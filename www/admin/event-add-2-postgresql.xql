<?xml version="1.0"?>

<queryset>
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="product_insert">      
      <querytext>

	select ec_product__new(
	null,
	:user_id,
	:event_id,
	'$activity_info(name) $date_time', 
	:event_price, 
	'event_$event_id',
	'$activity_info(name); $date_time; $venue_info(city), $venue_info(usps_abbrev)', 
	'$activity_info(description)', 
	'$activity_info(name), $venue_info(city), $venue_info(usps_abbrev), $venue_info(venue_name)', 
	't', 
	'i',
	null, 
	to_date(current_timestamp, 'YYYY-MM-DD'), 
	null,
	null,
	:peeraddr
	)

      </querytext>
</fullquery>

<fullquery name="mapping_insert">
	<querytext>
	insert into ec_category_product_map values (:product_id, :category_id, null, current_timestamp, :user_id, :peeraddr)
	</querytext>
</fullquery>
 
</queryset>
