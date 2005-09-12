# events/www/admin/venues-connecting.tcl

ad_page_contract {
    Allows admins to connect/disconnect venues.

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

set context_bar [ad_context_bar [list "venues" "Venues"] " Venue Connections"]

form create venue

element create venue venue_id \
    -label "Venue ID" \
    -datatype integer \
    -widget hidden

element create venue connect_to_id \
    -label "Connect Venue To" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_connecting_options -this_venue_id $venue_id -connecting "t"] \
    -optional \
    -value ""

element create venue disconnect_from_id \
    -label "Disconnect Venue From" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::venue::venues_get_connecting_options -this_venue_id $venue_id -connecting "f"] \
    -optional \
    -value ""

if {[template::form is_valid venue]} {
    template::form get_values venue \
        venue_id connect_to_id disconnect_from_id

    if { ![empty_string_p $connect_to_id] } {
	# Connect
	events::venue::connect -left_id $venue_id -right_id $connect_to_id
    }
    if { ![empty_string_p $disconnect_from_id] } {
	# Disconnect
	events::venue::disconnect -left_id $venue_id -right_id $disconnect_from_id
    }
    ad_returnredirect "venues"
    ad_script_abort
}

element set_properties venue venue_id -value $venue_id

ad_return_template