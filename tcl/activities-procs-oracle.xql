<?xml version="1.0"?>
<queryset>

    <fullquery name="events::activity::get.select_activity_info">
        <querytext>
	select a.name, a.description, ae.available_p, ae.detail_url,
	       ae.default_contact_user_id, u.email as default_contact_email,
	       u.first_names || ' ' || u.last_name as default_contact_name
	  from acs_activities a, events_activities ae, cc_users u
	 where a.activity_id = :activity_id
	       and a.activity_id = ae.activity_id
	       and ae.default_contact_user_id = u.user_id(+)
        </querytext>
    </fullquery>

    <fullquery name="events::activity::delete.delete_activity">
        <querytext>
	declare begin
		events_activity.del(:activity_id);
	end;
        </querytext>
    </fullquery>

</queryset>

