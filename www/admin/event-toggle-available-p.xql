<?xml version="1.0"?>
<queryset>

	<fullquery name="select_ecommerce_info">
		<querytext>
		select ec_products.product_id from acs_objects, ec_products where acs_objects.context_id=:event_id and acs_objects.object_id=ec_products.product_id
		</querytext>
	</fullquery>

</queryset>