<?xml version="1.0"?>

<queryset>
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="product_insert">      
      <querytext>

select ec_product__new(
	null,												-- integer
	:user_id,											-- integer
	:event_id,											-- integer
	'$activity_info(name) $date_time',								-- varchar
	:event_price,	      										-- numeric
	'event_$event_id',										-- varchar
	'$activity_info(name); $date_time; $venue_info(city), $venue_info(usps_abbrev)',		-- varchar
	'$activity_info(description)', 	   		      						-- varchar
	'$activity_info(name), $venue_info(city), $venue_info(usps_abbrev), $venue_info(venue_name)',	-- varchar
	't', 		       			  			    				-- boolean
	'i',												-- character
	null, 												-- varchar
	current_timestamp, 										-- timestamptz
	null,			   									-- varchar
	null,												-- varchar
	:peeraddr											-- varchar
)
      </querytext>
</fullquery>

<fullquery name="mapping_insert">
	<querytext>
	insert into ec_category_product_map values (:product_id, :category_id, null, current_timestamp, :user_id, :peeraddr)
	</querytext>
</fullquery>
 
</queryset>
