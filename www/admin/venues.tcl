# File:  events/www/admin/venues.tcl

ad_page_contract {
    Lists event venues.

    @param orderby for ad_table

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {orderby "venue_name"}
    {venue_id:optional ""}
    {parent_p:optional "f"}
} -validate {
    venue_exists -requires {venue_id} { 
	if { ![db_0or1row activity_exists "select venue_name from events_venues where venue_id=:venue_id"] } {
	    ad_complain "We couldn't find the venue you asked for."
	    return 0
	}
	return 1
    }
}

set context_bar [ad_context_bar "Venues"]

#the columns for ad_table
set col [list venue_name city state max_people connecting]

set table_def {
    {venue_name "Venue Name" {} {<td><a href=\"venues-ae?venue_id=$venue_id\">$venue_name</a></td>}}
    {city "City" {} {<td>$city</td>}}
    {state "State" {} {<td>$state</td>}}
    {max_people "Max People" {} {<td>$max_people</td>}}
    {connecting "Connecting" {} {<td><a href=\"venues-connecting?venue_id=$venue_id\">change</a> [events::venue::connecting -venue_id $venue_id]</td></tr><tr><td>&nbsp;&nbsp;<a href=\"venues?venue_id=$venue_id&parent_p=t\">(parents)</a>&nbsp;&nbsp;<a href=\"venues?venue_id=$venue_id&parent_p=f\">(children)</a>&nbsp;&nbsp;<a href=\"venues-hierarchy?venue_id=$venue_id\">(add/remove hierarchy)</a></td></tr>}}
}

if { [empty_string_p $venue_id] } {
    # Select top-level venues only
    set sql "
    select v.venue_id, v.venue_name, v.city,
    v.usps_abbrev as state, max_people
    from events_venues v where venue_id not in (select child_venue_id from events_venues_venues_map)
    [ad_order_by_from_sort_spec $orderby $table_def]"
} else {
    if { $parent_p } {
	# Select parent venues (if any) for this venue
	set sql "
	select v.venue_id, v.venue_name, v.city,
	v.usps_abbrev as state, max_people
	from events_venues v where venue_id in ([events::venue::all_parents_or_children -venue_id $venue_id -parent_p "t" -sql_p "t"])
	[ad_order_by_from_sort_spec $orderby $table_def]"
    } else {
	# Select children venues (if any) for this venue
	set sql "
	select v.venue_id, v.venue_name, v.city,
	v.usps_abbrev as state, max_people
	from events_venues v where venue_id in ([events::venue::all_parents_or_children -venue_id $venue_id -parent_p "f" -sql_p "t"])
	[ad_order_by_from_sort_spec $orderby $table_def]"
    }
}

set table [ad_table -Tcolumns $col -Tmissing_text "<em>There are no venues to display</em>" -Torderby $orderby venues_list $sql $table_def]