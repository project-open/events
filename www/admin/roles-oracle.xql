<?xml version="1.0"?>
<queryset>

    <fullquery name="select_roles">
        <querytext>
	select role, role_id, 
	       decode(public_role_p, 't', ' (public role)', '') as public_role_p
	  from events_organizer_roles
	 order by role asc
        </querytext>
    </fullquery>

</queryset>
