# events/www/order-check.tcl

ad_page_contract {
    Allows users to check the status of an order/registration
    
    @param reg_id The registration to check

    @author Matthew Geddert (geddert@yahoo.com)
    @creation date 2002-11-10
    @original OpenACS 3.x version author Bryan Che (bryanche@arsdigita.com)


} {
    {reg_id:naturalnum,notnull}
} -validate {
    registration_exists_p -requires {reg_id} {
	if { ![events::registration::exists_p -reg_id $reg_id] } {
	    ad_complain "We could not find the registration you asked for."
	    return 0
	}
	return 1
    }
}

set user_id [ad_verify_and_get_user_id]
ad_maybe_redirect_for_registration

# check and see if this reg belongs to this user
if { ![db_0or1row reg_exists {}] } {
    ad_return_warning "Could Not Find Registration" "We could not find the
                       registration you asked for, or the registration you
                       asked for does not belong to you."
}

events::registration::get -reg_id $reg_id -array reg_info
events::event::get -event_id $reg_info(event_id) -array event_info
events::venue::get -venue_id $event_info(venue_id) -array venue_info

set title "Registration Status for $event_info(name)"

set return_url "event-info?event_id=$reg_info(event_id)"

set context [list [list "event-info?event_id=$reg_info(event_id)" "$event_info(name) in $venue_info(city)"] "Registration Status"]

ad_return_template



