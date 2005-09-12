<?xml version="1.0"?>
<queryset>

    <fullquery name="select_time_now">
	<querytext>
	select to_char(sysdate, 'MONTH DD YYYY HH12:MI AM') from dual
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

</queryset>