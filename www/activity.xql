<?xml version="1.0"?>
<queryset>

	<fullquery name="activity_exists">
		<querytext>
		select 1
		  from events_activities
		 where activity_id = :activity_id
	        </querytext>
	</fullquery>

</queryset>
