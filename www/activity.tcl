# events/www/activity.tcl

ad_page_contract {
    Takes in an activity_id, displays the related activity
    to the user and shows all upcoming events for this activity.
    
    @param activity_id the activity in which we're interested

    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {activity_id:naturalnum,notnull}
} -properties {
    upcoming_events:multirow
} -validate {
    activity_exists -requires {activity_id} { 
	if { ![db_0or1row activity_exists {}] } {
	    ad_complain "We couldn't find the activity you asked for."
	    return 0
	}
	return 1
    }
}


events::security::require_read_activity -activity_id $activity_id
set admin_p [events::security::can_admin_activity_p -activity_id $activity_id]

events::activity::get -activity_id $activity_id -array activity_info

set context [list [list "index" "Events"] $activity_info(name)]

set title $activity_info(name)
set user_id [ad_verify_and_get_user_id]

if { [string equal $activity_info(available_p) f] } {
    ad_return_template "unavailable"
}

set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

db_multirow upcoming_events select_upcoming_events {}

ad_return_template
