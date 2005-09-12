<?xml version="1.0"?>
<queryset>

  <fullquery name="select_organizer_info">
	<querytext>
	select eo.role, eo.user_id, eo.role_id, eo.event_id,
	       u.first_names || ' ' || u.last_name as organizer_name
	  from events_organizers eo, cc_users u
	 where eo.role_id = :role_id
	   and eo.public_role_p = 't'
	   and u.user_id = eo.user_id
	   and u.user_id = :user_id
        </querytext>
  </fullquery>

  <fullquery name="select_bio">      
	<querytext>
	select attr_value
	  from acs_attribute_values
	 where object_id = :user_id
	   and attribute_id =
	       (select attribute_id
	          from acs_attributes
	         where object_type = 'person'
	           and attribute_name = 'bio')
	</querytext>
  </fullquery>

</queryset>
