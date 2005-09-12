# events/www/event-info.tcl

ad_page_contract {
    Displays event info

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$

} {
    {event_id:naturalnum,notnull}
} -validate {
    event_exists_p -requires {event_id} { 
	if { ![events::event::exists_p -event_id $event_id] } {
	    ad_complain "We couldn't find the event you asked for."
	    return 0
	}
	return 1
    }
}

set user_id [ad_verify_and_get_user_id]

if { [events::event::reg_deadline_elapsed_p -event_id $event_id] } {    
   set reg_deadline_has_passed_p t
} else {
   set reg_deadline_has_passed_p f
}

events::security::require_read_event -event_id $event_id
set admin_p [events::security::can_admin_event_p -event_id $event_id]
set can_register_p [events::security::can_register_for_event_p -event_id $event_id]

events::event::get -event_id $event_id -array event_info

db_0or1row get_reg_id {}
if {[exists_and_not_null reg_id]} {       
    set title "Already registered for $event_info(name)"
    events::registration::get -reg_id $reg_id -array reg_info
    events::venue::get -venue_id $event_info(venue_id) -array venue_info
} else {
    set title "$event_info(name) in $event_info(city) on $event_info(timespan)"
    set reg_id "0"
}        


multirow create organizers role role_id usr_id organizer_name bio view_url
db_foreach select_organizers {} {
    set bio [db_string select_bio {} -default ""]
    if { ![empty_string_p $bio] } {
        set view_url "organizer?[export_vars { user_id role_id }]"
    } else {
        set view_url {}
    }
    multirow append organizers $role $role_id $user_id $organizer_name $bio $view_url
}

set attachments_enabled_p [events::event::attachments_enabled_p]
if { $attachments_enabled_p } {
    multirow create attachments item_id name url
    foreach set element [attachments::get_attachments -object_id $event_id] {
        multirow append attachments [lindex $element 0] [lindex $element 1] [lindex $element 2] 
    }
}

set return_url [ad_return_url]
set title "$event_info(name) in $event_info(city) on $event_info(timespan)"
set context [list [list "index" "Events"] "$event_info(name)"]

set event_info(additional_note) [template::util::richtext::get_property contents $event_info(additional_note)]
ad_return_template
