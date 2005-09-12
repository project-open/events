# File:  events/www/admin/activity-field-delete.tcl

ad_page_contract {
    Allows admins to confirm the removal of a role
    associated with the selected activity/event

    @param activity_id the field's activity
    @param event_id the field's event
    @param attribute_name the name of the field's table column
    @param attribute_id the name of the field's table column

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {event_id ""}
    {activity_id ""}
    {role_id:integer}
}

events::organizer::get_role -role_id $role_id -array role_info

if {[exists_and_not_null event_id]} {
    events::event::get -event_id $event_id -array info
    set title "Remove Role from Event?"
    set context_bar [ad_context_bar [list "activities" Activities] [list "event?event_id=$event_id" Event] "Remove Role"]
} else {
    events::activity::get -activity_id $activity_id -array info
    set title "Remove Role from Activity?"
    set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] "Remove Role"]
}

set question "Remove role from $info(name)?"

form create role_remove

element create role_remove activity_id \
    -datatype integer \
    -optional \
    -widget hidden

element create role_remove event_id \
    -datatype integer \
    -optional \
    -widget hidden

element create role_remove role \
    -label "Role name" \
    -datatype text \
    -widget inform \
    -value $role_info(role)

element create role_remove role_id \
    -label "Role" \
    -datatype integer \
    -widget hidden \
    -value $role_id

element create role_remove submit \
    -label "Remove role" \
    -datatype text \
    -widget submit

if {[template::form is_valid role_remove]} {
    template::form get_values role_remove role_id
    if {[exists_and_not_null event_id]} {
	set redirect_url "event?event_id=$event_id"
	events::organizer::unmap_role \
		-event_id $event_id \
		-role_id $role_id
    } else {
	set redirect_url "activity?activity_id=$activity_id"
	events::organizer::unmap_role \
		-activity_id $activity_id \
		-role_id $role_id
    }

    ad_returnredirect $redirect_url
    ad_script_abort
}

if {[exists_and_not_null event_id]} {
    element set_properties role_remove activity_id -value $activity_id
    element set_properties role_remove event_id -value $event_id
} else {
    element set_properties role_remove activity_id -value $activity_id
}

ad_return_template
