# events/www/order-check.tcl

ad_page_contract {
    Allows users to check the status of an order/registration
    
    @param reg_id The registration to check

    @author Matthew Geddert (geddert@yahoo.com)
    @creation date 2002-11-10
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

events::registration::get -reg_id $reg_id -array reg_info
events::event::get -event_id $reg_info(event_id) -array event_info
events::venue::get -venue_id $event_info(venue_id) -array venue_info
events::event::get_stats -event_id $reg_info(event_id) -array event_stats

set title "Registration \#$reg_id"
set context [list [list "event?event_id=$reg_info(event_id)" "$event_info(name) in $venue_info(city)"] "Status of Registration"]

set count_spotsremaining [expr $event_stats(max_people) - $event_stats(approved)]

if { ![empty_string_p $event_stats(max_people)] && $count_spotsremaining == 0 } {
     set max_approved t
} else {
     set max_approved f
}



form create reg_comments

element create reg_comments reg_id \
    -datatype integer \
    -widget hidden \
    -value $reg_id

element create reg_comments comments \
    -label "Reg. Comments:" \
    -datatype text \
    -widget textarea \
    -html {cols 65 rows 6 wrap soft} \
    -optional \
    -value $reg_info(comments)

element create reg_comments submit \
    -label "Update" \
    -datatype text \
    -widget submit
	
if {[form is_submission reg_comments]} {
    template::form get_values reg_comments comments reg_id

    events::registration::edit_reg_comments \
	-reg_id $reg_id \
        -comments $comments

    ad_returnredirect "reg-view?reg_id=$reg_id"
}

ad_return_template
