<?xml version="1.0"?>
<queryset>

    <fullquery name="select_roles">
        <querytext>
	select role, role_id, public_role_p,
                CASE when public_role_p = 't' then ' (public role)'
                ELSE ''
                END
	  from events_organizer_roles
	 order by role asc
        </querytext>
    </fullquery>

</queryset>
