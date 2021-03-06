<?xml version="1.0"?>
<queryset>

    <fullquery name="select_available_activity_roles">
        <querytext>
	select role || ' ' ||
	       decode(public_role_p, 't', ' (public role)', '') as public_role_p,
	       role_id
	  from events_organizer_roles
	 where role_id not in
	       (select role_id 
		  from events_org_role_activity_map 
		 where activity_id = :activity_id)
        </querytext>
    </fullquery>

    <fullquery name="select_available_event_roles">
        <querytext>
	select role || ' ' ||
	       decode(public_role_p, 't', ' (public role)', '') as public_role_p,
	       role_id
	  from events_organizer_roles
	 where role_id not in
	       (select role_id 
		  from events_org_role_event_map 
		 where event_id = :event_id)
        </querytext>
    </fullquery>

</queryset>
