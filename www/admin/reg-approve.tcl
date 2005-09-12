# events/www/admin/reg-approve.tcl
ad_page_contract {

    Approve a Registration.

    @param  reg_id the registration to cancel

    @author Matthew Geddert (geddert@yahoo.com)
    @creation date 2002-11-11

} {
    {reg_id:naturalnum,notnull}
    {return_url ""}
} -validate {
    registration_exists_p -requires {reg_id} { 
	if { ![events::registration::exists_p -reg_id $reg_id] } {
	    ad_complain "We could not find the registration you asked for."
	    return 0
	}
	return 1
    }
}

events::registration::get -reg_id $reg_id -array reg_info
events::event::get_stats -event_id $reg_info(event_id) -array event_stats

set count_spotsremaining [expr $event_stats(max_people) - $event_stats(approved)]

if { ![empty_string_p $event_stats(max_people)] && $count_spotsremaining == 0 } {
     ad_return_error "Max Number Already Reached" "The maximum number of registrations for this event has already been reached. 
                      You cannot approve of this registration before cancelling or waitlisting somebody else, or editing
                      the maximum number of registrants allowed for this event."
} else {
    events::registration::approve -reg_id $reg_id

    if {![exists_and_not_null return_url]} {
        set return_url "reg-view?reg_id=$reg_id"
    }        

    ad_returnredirect $return_url
}

ad_script_abort
