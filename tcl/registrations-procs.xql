<?xml version="1.0"?>
<queryset>

    <fullquery name="events::registration::edit_reg_comments.edit_reg_comments">
	<querytext>
	update events_registrations
	   set comments = :comments
	 where reg_id = :reg_id
	</querytext>
    </fullquery>

    <fullquery name="events::registration::exists_p.exists_p_select">
	<querytext>
	select 1 
          from events_registrations er,
               events_activities ea,
               acs_events ae
         where er.reg_id = :reg_id
           and er.event_id = ae.event_id
           and ae.activity_id = ea.activity_id
           and ea.package_id = :package_id 
	</querytext>
    </fullquery>

    <fullquery name="events::registration::waiting.waiting_registration">
        <querytext>
	update events_registrations
	   set reg_state = 'waiting'
	 where reg_id = :reg_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::approve.approve_registration">
        <querytext>
	update events_registrations
	   set reg_state = 'approved'
	 where reg_id = :reg_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::cancel.cancel_registration">
        <querytext>
	update events_registrations
	   set reg_state = 'canceled'
	 where reg_id = :reg_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::edit.edit_registration">
        <querytext>
	update events_registrations
	   set reg_state = :reg_state,
	       user_id = :party_id
	  where reg_id = :reg_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::new_attribute.insert_into_events_attr_category_map">
        <querytext>
	insert into events_attr_category_map 
	(attribute_id, category_id)
	values
	(:attribute_id, :category_id)
        </querytext>
    </fullquery>

    <fullquery name="events::registration::get_attribute.select_attribute_info">
        <querytext>
	select aa.attribute_id, aa.attribute_name as name,
       	       aa.sort_order, aa.datatype, aa.pretty_name,
	       aa.pretty_plural, eac.category_name, eac.category_id
	  from acs_attributes aa, events_attr_categories eac, 
	       events_attr_category_map eacm
	 where aa.attribute_id = :attribute_id
	   and aa.attribute_id = eacm.attribute_id
	   and eacm.category_id = eac.category_id
        </querytext>
    </fullquery>f

    <fullquery name="events::registration::edit_attribute.edit_reg_attribute">
        <querytext>
	update acs_attributes
	   set attribute_name = :attribute_name,
	       pretty_name = :pretty_name,
	       pretty_plural = :pretty_plural,
	       datatype = :datatype
	 where attribute_id = :attribute_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::edit_attribute.edit_reg_attr_category">
        <querytext>
	update events_attr_category_map
	   set category_id = :category_id
	 where attribute_id = :attribute_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::delete_attribute.del_from_events_attr_category_map">
        <querytext>
	delete from events_attr_category_map
	 where attribute_id = :attribute_id
	</querytext>
    </fullquery>

    <fullquery name="events::registration::map_attribute.insert_into_events_event_attr_map">
        <querytext>
	insert into events_event_attr_map
	(event_id, attribute_id)
	values
	(:event_id, :attribute_id)
        </querytext>
    </fullquery>

    <fullquery name="events::registration::map_attribute.insert_into_events_def_actvty_attr_map">
        <querytext>
	insert into events_def_actvty_attr_map
	(activity_id, attribute_id)
	values
	(:activity_id, :attribute_id)
        </querytext>
    </fullquery>

    <fullquery name="events::registration::unmap_attribute.delete_from_events_event_attr_map">
        <querytext>	
	delete from events_event_attr_map
	 where attribute_id = :attribute_id
	</querytext>
    </fullquery>

    <fullquery name="events::registration::unmap_attribute.delete_from_events_def_actvty_attr_map">
        <querytext>	
	delete from events_def_actvty_attr_map
	 where attribute_id = :attribute_id
	</querytext>
    </fullquery>

    <fullquery name="events::registration::get_sort_order.get_sort_order_max">
        <querytext>
	select max(aa.sort_order) as sort_order_max
	  from acs_attributes aa, events_attr_category_map eacm
	 where category_id = :category_id
	   and aa.attribute_id = eacm.attribute_id
        </querytext>
    </fullquery>

</queryset>
