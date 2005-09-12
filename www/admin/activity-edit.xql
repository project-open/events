<?xml version="1.0"?>
<queryset>

    <fullquery name="activity_exists">
	<querytext>
	select 1
	  from events_activities
	 where activity_id = :activity_id
        </querytext>
    </fullquery>

    <fullquery name="select_activity_info">
        <querytext>
		select a.name, 
		a.description, 
		ae.available_p,
		ae.detail_url,
		ae.default_contact_user_id
		from   acs_activities a, events_activities ae
		where  a.activity_id = :activity_id
		and a.activity_id = ae.activity_id
        </querytext>
    </fullquery>

</queryset>
