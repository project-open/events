<?xml version="1.0"?>
<queryset>

	<fullquery name="select_org_roles">
		<querytext>
		select eo.role, eo.user_id, eo.role_id, eo.event_id,
		       decode(eo.public_role_p, 't', '(public role)', '') as public_role_p,
		       p.first_names || ' ' || p.last_name as organizer_name
		  from events_organizers eo, users u, persons p
		 where eo.user_id = u.user_id(+)
		   and p.person_id(+) = u.user_id
		   and eo.event_id = :event_id
		 order by role
		</querytext>
	</fullquery>

</queryset>

