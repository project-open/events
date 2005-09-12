<?xml version="1.0"?>
<queryset>

    <fullquery name="events::organizer::get_role.select_org_role_info">
        <querytext>
	select role, responsibilities, public_role_p, eom.user_id
	  from events_organizer_roles eor left join events_organizers_map eom using ( role_id )
	 where eor.role_id = :role_id
        </querytext>
    </fullquery>

</queryset>
