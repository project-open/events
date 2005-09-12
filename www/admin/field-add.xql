<?xml version="1.0"?>
<queryset>

    <fullquery name="select_available_activity_fields">
        <querytext>
	select eac.category_name || ' >> ' || aa.attribute_name || ' ( datatype : ' || aa.datatype || ' )' as name,
	       aa.attribute_id
	  from acs_attributes aa, events_attr_categories eac, 
	       events_attr_category_map eacm
	 where eacm.attribute_id = aa.attribute_id
	   and eacm.category_id = eac.category_id
	   and aa.attribute_id not in (select attribute_id
				     from events_def_actvty_attr_map
				    where activity_id = :activity_id)
	 order by name asc
        </querytext>
    </fullquery>

    <fullquery name="select_available_event_fields">
        <querytext>
	select eac.category_name || ' >> ' || aa.attribute_name || ' ( datatype : ' || aa.datatype || ' )' as name,
	       aa.attribute_id
	  from acs_attributes aa, events_attr_categories eac, 
	       events_attr_category_map eacm
	 where eacm.attribute_id = aa.attribute_id
	   and eacm.category_id = eac.category_id
	   and aa.attribute_id not in (select attribute_id
				     from events_event_attr_map
				    where event_id = :event_id)
	 order by name asc
        </querytext>
    </fullquery>

</queryset>
