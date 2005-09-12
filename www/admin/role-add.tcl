# File:  events/www/admin/role-add.tcl

ad_page_contract {
    Allows admins to select from existing system roles

    @param activity_id the field's activity
    @param event_id the field's event

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {event_id ""}
    {activity_id ""}
    {role_ids:multiple ""}
}

if {[exists_and_not_null event_id]} {
    set title "Add Organizer Roles"
    set role_create "role-create?activity_id=$activity_id&event_id=$event_id"
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] \
	    [list "event?event_id=$event_id" "Event"] "Add Organizer Roles"]
    set roles [db_list_of_lists select_available_event_roles {}]
} else {
    set title "Add Default Organizer Roles"
    set role_create "role-create?activity_id=$activity_id"
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] "Add Default Organizer Roles"]
    set roles [db_list_of_lists select_available_activity_roles {}]
}

if {[exists_and_not_null roles]} {
    set roles_p t
} else {
    set roles_p f
}

form create role_add

element create role_add activity_id \
	-optional \
	-widget hidden \
	-datatype integer

element create role_add event_id \
	-optional \
	-widget hidden \
	-datatype integer

element create role_add role_ids \
	-label "Available Roles" \
	-widget multiselect \
	-datatype integer \
	-help_text "Select multiple roles by holding down the Control key" \
	-options $roles

element create role_add submit \
	-label "Add roles" \
	-datatype text \
	-widget submit

if {[template::form is_valid role_add]} {

    if {[exists_and_not_null event_id]} {
	foreach role_id $role_ids {
	    events::organizer::map_role -event_id $event_id -role_id $role_id
	}
	set redirect_url "event?event_id=$event_id"
    } else {
	foreach role_id $role_ids {
	    events::organizer::map_role -activity_id $activity_id -role_id $role_id
	}
	set redirect_url "activity?activity_id=$activity_id"
    }

    ad_returnredirect $redirect_url
    ad_script_abort

}

if {[exists_and_not_null event_id]} {
    element set_properties role_add activity_id -value $activity_id
    element set_properties role_add event_id -value $event_id
} else {
    element set_properties role_add activity_id -value $activity_id
}

ad_return_template
