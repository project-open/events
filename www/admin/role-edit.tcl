#/packages/events/www/admin/role-edit.tcl

ad_page_contract {
    
    Edit an org role for either an event or an activity

    @param activity_id the activity in question
    @param event_id the event in question
    @param role_id the role which we're to edit

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {role_id:naturalnum,notnull}
    {event_id:naturalnum,optional}
    {activity_id:naturalnum,optional}
}

events::organizer::get_role -role_id $role_id -array org_role_info

form create organizer_role

if {[exists_and_not_null event_id]} {
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] \
	    [list "event?event_id=$event_id" "Event"] "Edit Organizer Role"]
    set title "Edit Organizer Role"
} elseif {[exists_and_not_null activity_id]} {
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] "Edit Organizer Role"]
    set title "Edit Default Activity Organizer Role"
} else {
    set context_bar [ad_context_bar [list "roles" "Roles"] \
	    [list "one-role?role_id=$role_id" "One Role"] "Edit Organizer Role"]
    set title "Edit Organizer Role"
}

element create organizer_role activity_id \
	-datatype integer \
	-widget hidden \
	-optional

element create organizer_role event_id \
	-datatype integer \
	-widget hidden \
	-optional

element create organizer_role role_id \
	-datatype integer \
	-widget hidden \
	-value $role_id

element create organizer_role role \
	-label "Role" \
	-datatype text \
	-widget text \
	-html {size 20} \
	-required

element create organizer_role responsibilities \
	-label "Responsibilities" \
	-datatype text \
	-widget textarea \
	-html {cols 70 rows 10 wrap soft} 


element create organizer_role public_role_p \
	-label "Public Role?" \
	-datatype text \
	-widget select \
	-options {{No f} {Yes t}}

if {[template::form is_valid organizer_role]} {
    template::form get_values organizer_role \
	    role_id role responsibilities public_role_p event_id

    if {[exists_and_not_null event_id]} {
	set redirect_url "event?event_id=$event_id"
    } elseif {[exists_and_not_null activity_id]} {
	set redirect_url "activity?activity_id=$activity_id"
    } else {
	set redirect_url "one-role?role_id=$role_id"
    }
    
    events::organizer::edit_role \
	    -role_id $role_id \
	    -role $role \
	    -responsibilities $responsibilities \
	    -public_role_p $public_role_p

    ad_returnredirect $redirect_url
    ad_script_abort
}

element set_properties organizer_role role -value $org_role_info(role)
element set_properties organizer_role responsibilities -value $org_role_info(responsibilities)
element set_properties organizer_role public_role_p -value $org_role_info(public_role_p)

if {[exists_and_not_null event_id]} {
    element set_properties organizer_role event_id -value $event_id
} elseif {[exists_and_not_null activity_id]} {
    element set_properties organizer_role activity_id -value $activity_id
}

ad_return_template




