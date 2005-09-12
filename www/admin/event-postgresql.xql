<?xml version="1.0"?>
<queryset>

	<fullquery name="select_org_roles">
		<querytext>
		 select eo.role, eo.user_id, eo.role_id, eo.event_id,
                                CASE WHEN eo.public_role_p THEN '(public role)'
                                     ELSE ''
                                END as public_role_p,
		       p.first_names || ' ' || p.last_name as organizer_name
		  from
		     events_organizers eo left join users u on (eo.user_id = u.user_id),
		     persons p
                 where eo.event_id = :event_id
                   and p.person_id = u.user_id
                 order by role
 		</querytext>
 	</fullquery>

</queryset>
