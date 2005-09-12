# /events/www/admin/activity.tcl

ad_page_contract {
    Displays a particular activity to an admin, with options
    for modifying the event.    
    
    @param activity_id the activity at which we're looking

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    activity_id:integer,notnull
} -validate {
    activity_exists -requires {activity_id} { 
	if { ![events::activity::exists_p -activity_id $activity_id] } {
	    ad_complain "We couldn't find the activity you asked for."
	    return 0
	}
	return 1
    }
}


set package_id [ad_conn package_id]

events::activity::get -activity_id $activity_id -array activity_info
events::activity::get_creator -activity_id $activity_id -array creator_info
events::activity::get_stats -activity_id $activity_id -array activity_stats

set context [list [list activities "Activities"] $activity_info(name)]

set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

set events ""
db_foreach select_activity_events {} {
    # do something for each group of which user 123456 is in the role
    # of "administrator"
    events::event::get_stats -event_id $event_id -array event_stats

    append events "<li><a href=\"event?event_id=$event_id\">"
    if { [empty_string_p $city] } {
	append events "$name"
    } else {
	append events "$city"
    }
    if { ![empty_string_p $usps_abbrev] } {
	if { ![empty_string_p $city] } {
	    append events ", "
	} else {
	    append events " - "
	}
	append events "$usps_abbrev"
    }
    append events "</a> - $timespan - "
    if { [empty_string_p $event_stats(max_people)] } {
	append events "unlimited registrations"
    } else {
	append events "(<b>[expr $event_stats(max_people) - $event_stats(approved)]<\/b> of $event_stats(max_people) spots left"
    }

    if {![string compare $event_stats(pending) "0"] == 0} {
	append events " with <font color=\"red\">$event_stats(pending) pending<\/font>"
	if {![string compare $event_stats(waiting) "0"] == 0} {
	    append events " and <font color=\"blue\">$event_stats(waiting) waiting<\/font>"
	}
    } else {
	if {![string compare $event_stats(waiting) "0"] == 0} {
	    append events " with <font color=\"blue\">$event_stats(waiting) waiting<\/font>"
	}
    }
    
    if { ![empty_string_p $event_stats(max_people)] } {
	append events ")"
    }
}

if {![exists_and_not_null events]} {       
     set events "<li>No events for this activity have been created.<\/li>"
}        


db_multirow custom_fields select_custom_fields {}
db_multirow org_roles select_org_roles {}

ad_return_template
