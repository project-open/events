<?xml version="1.0"?>
<queryset>

    <fullquery name="select_attribute_datatypes">
        <querytext>
	select datatype, datatype
	  from acs_datatypes
        </querytext>
    </fullquery>

    <fullquery name="select_categories">
        <querytext>
	select  category_name, category_id
	  from events_attr_categories
        </querytext>
    </fullquery>

</queryset>
