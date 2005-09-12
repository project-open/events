<?xml version="1.0"?>
<queryset>

	<fullquery name="select_event_organizers_count">
		<querytext>
		select count(*)
		  from events_organizers
		 where event_id = :event_id
		   and user_id is not null
		</querytext>
	</fullquery>

	<fullquery name="select_event_organizers_email">
		<querytext>
		select distinct users.priv_email, users.user_id
		  from users, events_organizers eo, events_org_role_event_map eorem
		 where eorem.event_id = :event_id
		   and eorem.role_id = eo.role_id
		   and users.user_id = eo.user_id
		 order by users.user_id
		</querytext>
	</fullquery>

        <fullquery name="select_custom_fields">
		 <querytext>
		select eaam.attribute_id, aa.attribute_name as name,
	       	       aa.sort_order as after, aa.datatype, 
		       eac.category_name, eac.category_id
		  from events_event_attr_map eaam, acs_attributes aa,
		       events_attr_categories eac, events_attr_category_map eacm
		 where eaam.event_id = :event_id
		   and eaam.attribute_id = aa.attribute_id
		   and eacm.attribute_id = aa.attribute_id
		   and eacm.category_id = eac.category_id
		 order by eac.category_name, aa.sort_order asc
	        </querytext>
	</fullquery>

	<fullquery name="select_event_fields_old">
		<querytext>
		select column_name, pretty_name, column_type, column_actual_type,
		       column_extra, sort_key
		  from events_event_fields
		 where event_id = :event_id
		 order by sort_key 
		</querytext>
	</fullquery>

</queryset>
