<?xml version="1.0"?>
<queryset>

    <fullquery name="select_activity_properties">
        <querytext>
	select a.name, 
	       a.description, 
	       ae.available_p,
	       ae.detail_url,
	       ae.default_contact_user_id
	  from acs_activities a, events_activities ae
	 where a.activity_id = :activity_id
	   and a.activity_id = ae.activity_id
        </querytext>
    </fullquery>

    <fullquery name="custom_fields_old">
        <querytext>
	select column_name, pretty_name, column_type, column_actual_type,
	       column_extra, sort_key
	  from events_activity_fields
	 where activity_id = :activity_id
	 order by sort_key
        </querytext>
    </fullquery>

    <fullquery name="select_custom_fields">
        <querytext>
	select edaam.attribute_id, aa.attribute_name as name,
	       aa.sort_order as after, aa.datatype, eac.category_name,
	       eac.category_id
	  from events_def_actvty_attr_map edaam, acs_attributes aa,
	       events_attr_categories eac, events_attr_category_map eacm
	 where edaam.activity_id = :activity_id
	   and edaam.attribute_id = aa.attribute_id
	   and eacm.attribute_id = aa.attribute_id
	   and eacm.category_id = eac.category_id
	 order by eac.category_name, aa.sort_order asc
        </querytext>
    </fullquery>

</queryset>



