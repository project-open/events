# events/www/admin/venues-hierarchy.tcl

ad_page_contract {
    Allows admins to make levels of venues.

    @param venue_id the venue to edit

    @author Brad Duell (bduell@ncacasi.org)
} {
    {venue_id:naturalnum,notnull}
} -validate {
    venue_exists -requires {venue_id} { 
	if { ![db_0or1row activity_exists "select venue_name from events_venues where venue_id=:venue_id"] } {
	    ad_complain "We couldn't find the venue you asked for."
	    return 0
	}
	return 1
    }
}

set context_bar [ad_context_bar [list "venues" "Venues"] " Venue Hierarchy"]

form create venue

element create venue venue_id \
    -label "Venue ID" \
    -datatype integer \
    -widget hidden

element create venue add_parent_id \
    -label "Add Parent" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_hierarchy_options -this_venue_id $venue_id -parent_p "t" -add_p "t"] \
    -optional \
    -value ""

element create venue remove_parent_id \
    -label "Remove Parent" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_hierarchy_options -this_venue_id $venue_id -parent_p "t" -add_p "f"] \
    -optional \
    -value ""

element create venue add_child_id \
    -label "Add Child" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_hierarchy_options -this_venue_id $venue_id -parent_p "f" -add_p "t"] \
    -optional \
    -value ""

element create venue remove_child_id \
    -label "Remove Child" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_hierarchy_options -this_venue_id $venue_id -parent_p "f" -add_p "f"] \
    -optional \
    -value ""

if {[template::form is_valid venue]} {
    template::form get_values venue \
        venue_id add_parent_id remove_parent_id add_child_id remove_child_id

    if { ![empty_string_p $add_parent_id] } {
	# Add Parent
	if { $add_parent_id != $add_child_id } {
	    events::venue::make_child_of -parent_id $add_parent_id -child_id $venue_id
	}
    }
    if { ![empty_string_p $remove_parent_id] } {
	# Remove Parent
	events::venue::dechildize -parent_id $remove_parent_id -child_id $venue_id
    }
    if { ![empty_string_p $add_child_id] } {
	# Add Child
	if { $add_parent_id != $add_child_id } {
	    events::venue::make_child_of -parent_id $venue_id -child_id $add_child_id
	}
    }
    if { ![empty_string_p $remove_child_id] } {
	# Remove Child
	events::venue::dechildize -parent_id $venue_id -child_id $remove_child_id
    }
    ad_returnredirect "venues"
    ad_script_abort
}

element set_properties venue venue_id -value $venue_id

ad_return_template