<?xml version="1.0"?>
<queryset>

        <fullquery name="select_custom_fields">
		 <querytext>
		select aa.attribute_id, aa.attribute_name as name,
	       	       aa.sort_order as after, aa.datatype, 
		       eac.category_name, eac.category_id
		  from acs_attributes aa, events_attr_categories eac, 
		       events_attr_category_map eacm
		 where aa.attribute_id = eacm.attribute_id
		   and eacm.category_id = eac.category_id
		 order by eac.category_name, aa.sort_order asc
	        </querytext>
	</fullquery>

</queryset>
