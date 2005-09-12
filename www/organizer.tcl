ad_page_contract {
    Displays information about an event organizer

    @param role_id the organizer's role
    @param user_id the organizer

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {role_id:integer,notnull}
    {user_id:integer,notnull}
} -validate {
    organizer_check -requires {role_id user_id} { 
	if { ![db_0or1row select_organizer_info {}] } {
	    ad_complain "Invalid Organizer Request This page
	    came in with an invalid organizer request."
	    return 0
	}
	return 1
    }
}

events::event::get -event_id $event_id -array event_info

set title "$organizer_name: $role for $event_info(name)"
set context [list [list "event-info?event_id=$event_id" "One Event"] "$role"]

set bio [db_string select_bio {}]
set bio [ad_decode $bio "" "$organizer_name has not provided any information about himself to display" $bio]

ad_return_template

