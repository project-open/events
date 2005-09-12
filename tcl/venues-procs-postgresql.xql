<?xml version="1.0"?>
<queryset>

    <fullquery name="events::venue::new.new_acs_venue">
        <querytext> 
	select acs_object__new (
		null,
                'events_venue',
		now(),
                :user_id,
		:creation_ip,
                :context_id
        )
        </querytext>
    </fullquery>

	<fullquery name="events::venue::new.new">
		<querytext>
		select events_venue__new(
			:venue_id,
			'events_venue',
			:venue_name,
			:address1,
			:address2,
			:city,
			:phone_number,
			:fax_number,
			:email,
			:needs_reserve_p,
			:max_people,
			:description,
			:creation_date,
			null,
			null,
			null,
			)	
		</querytext>
	</fullquery>

	<fullquery name="events::venue::delete.delete_venue">
		<querytext>
		select events_venue__delete(:venue_id);
		</querytext>
	</fullquery>

	<fullquery name="events::venue::in_use_p.in_use_p_select">
		<querytext>
		select 1 from events_events
		 where venue_id = :venue_id
		 limit 1
		</querytext>
	</fullquery>

	<fullquery name="events::venue::child_of_p.select_parents">
		<querytext>
		select 1 from events_venues where $parent_id in ([events::venue::all_parents_or_children -venue_id $child_id -package_id $package_id -sql_p "t" -parent_p "t"]) limit 1
		</querytext>
	</fullquery>

</queryset>
