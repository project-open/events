<?xml version="1.0"?>
<queryset>

	<fullquery name="reg_exists">
		<querytext>
		select 1
		  from events_registrations
		 where reg_id = :reg_id
                   and user_id = :user_id
	        </querytext>
	</fullquery>

</queryset>
