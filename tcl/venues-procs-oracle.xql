<?xml version="1.0"?>
<queryset>

    <fullquery name="events::venue::new.new_acs_venue">
        <querytext> 
	declare	begin 
	:1 := acs_object.new (
		object_type => 'events_venue',
		creation_user => :user_id,
		creation_ip => :creation_ip,
		context_id => :context_id
	);
	end;
        </querytext>
    </fullquery>

	<fullquery name="events::venue::delete.delete_venue">
		<querytext>
		declare begin
			events_venue.del(:venue_id);
		end;
		</querytext>
	</fullquery>

	<fullquery name="events::venue::in_use_p.in_use_p_select">
		<querytext>
		select 1 from events_events
		 where venue_id = :venue_id
		   and rownum = 1
		</querytext>
	</fullquery>

	<fullquery name="events::venue::child_of_p.select_parents">
		<querytext>
		select 1 from events_venues where $parent_id in ([events::venue::all_parents_or_children -venue_id $child_id -package_id $package_id -sql_p "t" -parent_p "t"]) and rownum = 1
		</querytext>
	</fullquery>

</queryset>
