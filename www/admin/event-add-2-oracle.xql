<?xml version="1.0"?>

<queryset>
	<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="product_insert">      
	<querytext>

	    begin
	        :1 := ec_product.new(
		creation_user => :user_id,
		creation_ip => :peeraddr,
		context_id => :event_id,
		product_name => '$activity_info(name) $date_time',
		price => :event_price,
		sku => 'event_$event_id',
		one_line_description => '$activity_info(name); $date_time; $venue_info(city), $venue_info(usps_abbrev)',
		detailed_description => '$activity_info(description)', 
		search_keywords => '$activity_info(name), $venue_info(city), $venue_info(usps_abbrev), $venue_info(venue_name)', 
		present_p => 't', 
		stock_status => 'i',
		email_on_purchase_list => :email, 
		url => '$activity_info(detail_url)',
		no_shipping_avail_p => 't',
		active_p => 't'
	    );
	    end;
      
	</querytext>
</fullquery>

<fullquery name="mapping_insert">
	<querytext>
	insert into ec_category_product_map values (:product_id, :category_id, null, sysdate, :user_id, :peeraddr)
	</querytext>
</fullquery>

</queryset>