<?xml version="1.0"?>
<queryset>

    <fullquery name="get_reg_id">
	<querytext>
	select reg_id
	  from events_registrations
	 where event_id = :event_id
           and user_id = :user_id
           and reg_state <> 'canceled'
	</querytext>
    </fullquery>

    <fullquery name="select_custom_fields">
	 <querytext>
	select eaam.attribute_id, aa.attribute_name as name,
       	       aa.sort_order as after, aa.datatype, aa.pretty_name,
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

</queryset>
