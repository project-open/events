<?xml version="1.0"?>

<queryset>
	<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_ecommerce_info">
	<querytext>
	select
		ec_products.product_id,
		ec_products.price,
		ec_category_product_map.category_id,
		min(sale_price) as sale_price 
	from 
		acs_objects,
		ec_products 
		left join ec_category_product_map 
			on ec_category_product_map.product_id=ec_products.product_id 
		left join ec_sale_prices_current 
			on ec_sale_prices_current.product_id=ec_products.product_id 
	where 
		acs_objects.context_id=:event_id 
		and acs_objects.object_id=ec_products.product_id 
	group by 
		ec_products.product_id,
		ec_products.price,
		ec_category_product_map.category_id
	</querytext>
</fullquery>
 
<fullquery name="select_product_id">
	<querytext>
	select
		ec_products.product_id 
	from 
		acs_objects,
		ec_products 
		left join ec_category_product_map 
			on ec_category_product_map.product_id=ec_products.product_id 
	where 
		acs_objects.context_id=:event_id 
		and acs_objects.object_id=ec_products.product_id
	</querytext>
</fullquery>

<fullquery name="product_update">
	<querytext>
	update ec_products
	set 
		product_name='$activity_info(name) $date_time',
		sku='event_$event_id',
		one_line_description='$activity_info(name); $date_time; $pretty_location',
		detailed_description='$activity_info(description)',
		email_on_purchase_list=:email,
		search_keywords='$activity_info(name),
		$venue_info(venue_name),
		$pretty_location',
		url='$activity_info(detail_url)',
		price=:event_price,
		no_shipping_avail_p='t',
		present_p='$event_info(available_p)',
		available_date=now(),
		$audit_update
	where 
		product_id=:product_id
	</querytext>
</fullquery>


<fullquery name="audit_update_sql">
	<querytext>
	last_modified=current_timestamp,
	last_modifying_user=:user_id,
	modified_ip_address=:peeraddr
	</querytext>
</fullquery>

<fullquery name="mapping_insert">
	<querytext>
	insert into ec_category_product_map values (
		:product_id,
		:category_id,
		null,
		current_timestamp,
		:user_id,
		:peeraddr
	)
	</querytext>
</fullquery>

<fullquery name="product_insert">      
      <querytext>

	select ec_product__new(
		null,
		:user_id,
		:event_id,
		'$activity_info(name) $date_time',
		:event_price,
		'event_$event_id',
		'$activity_info(name); $date_time; $pretty_location',
		'$activity_info(description)',
		'$activity_info(name),
		$venue_info(venue_name),
		$pretty_location',
		't',
		'i',
		null,
		to_date(current_timestamp,
		'YYYY-MM-DD'),
		null,
		null,
		:peeraddr
	)

      </querytext>
</fullquery>

<fullquery name="product_delete">      
      <querytext>
      select ec_product__delete(:product_id)
      </querytext>
</fullquery>

</queryset>
