<?xml version="1.0"?>
<queryset>

    <fullquery name="events::activity::get.select_activity_info">
        <querytext>
        select a.name, a.description, ae.available_p, ae.detail_url,
               ae.default_contact_user_id, u.email as default_contact_email,
               u.first_names || ' ' || u.last_name as default_contact_name
          from acs_activities a, events_activities ae left join cc_users u on (ae.default_contact_user_id = u.user_id)
         where a.activity_id = :activity_id
               and a.activity_id = ae.activity_id
        </querytext>
    </fullquery>

    <fullquery name="events::activity::delete.delete_activity">
        <querytext>
	select
		events_activity__del(:activity_id);
	</querytext>
    </fullquery>

</queryset>

