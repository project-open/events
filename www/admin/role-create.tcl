#/packages/events/www/admin/role-create.tcl

ad_page_contract {
    
    Create an org role 

    @param activity_id the activity in question
    @param event_id the event in question
    @param role_id the role which we're to edit

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {activity_id:naturalnum,optional}
    {event_id:naturalnum,optional}
}

if {[exists_and_not_null event_id]} {
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] \
	    [list "event?event_id=$event_id" "Event"] "New Organizer Role"]
    set title "Add a New Organizer Role"
} elseif {[exists_and_not_null activity_id]} {
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] "New Default Organizer Role"]
    set title "Add a New Default Organizer Role"
} else {
    set context_bar [ad_context_bar [list "roles" "Roles"] "New Organizer Role"]
    set title "Add a New Organizer Role"
}

form create organizer_role

element create organizer_role activity_id \
    -datatype integer \
    -widget hidden \
    -optional

element create organizer_role event_id \
    -datatype integer \
    -widget hidden \
    -optional

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
    -optional \
    -html {cols 70 rows 10 wrap soft} 

element create organizer_role public_role_p \
    -label "Public Role?" \
    -datatype text \
    -widget select \
    -options {{No f} {Yes t}}

if {[exists_and_not_null event_id]} {
    element create organizer_role user_id \
  	    -label "User in this role" \
  	    -datatype search \
  	    -widget search \
  	    -result_datatype integer \
  	    -options [events::organizer::users_get_options] \
  	    -optional \
  	    -search_query {
  	select distinct u.first_names || ' ' || u.last_name as name, u.user_id
  	from cc_users u
  	where upper(decode(u.first_names,' ', '')  || decode(u.last_name,' ', '') || u.email || ' ' || decode(u.screen_name, ' ', '')) like upper('%'||:value||'%')
  	order by name
    }

    element create organizer_role submit \
	    -label "Add a Role" \
	    -datatype text \
	    -widget submit

} else {
    element create organizer_role submit \
	    -label "Add a Default Role" \
	    -datatype text \
	    -widget submit

}

if {[template::form is_submission organizer_role]} {

    if {[exists_and_not_null event_id]} {
	# create role and map to event_id
	set redirect_url "event?event_id=$event_id"
	template::form get_values organizer_role \
		role responsibilities public_role_p user_id
	set role_id [events::organizer::new_role \
		-role $role \
		-responsibilities $responsibilities \
		-public_role_p $public_role_p]
	events::organizer::map_role -role_id $role_id -event_id $event_id
	if {[exists_and_not_null user_id]} {
	    # add organizer while we're at it
	    events::organizer::add_organizer -role_id $role_id \
		    -party_id $user_id -event_id $event_id
	}
    } elseif {[exists_and_not_null activity_id]} {
	# create role and map to activity_id
	set redirect_url "activity?activity_id=$activity_id"
	template::form get_values organizer_role \
		role responsibilities public_role_p
	set role_id [events::organizer::new_role \
		-role $role \
		-responsibilities $responsibilities \
		-public_role_p $public_role_p]
	events::organizer::map_role -role_id $role_id -activity_id $activity_id
    } else {
	# no event/activity association; just create the role
	set redirect_url "roles"
        template::form get_values organizer_role role public_role_p responsibilities
	events::organizer::new_role \
		-role $role \
		-responsibilities $responsibilities \
		-public_role_p $public_role_p
    }

    ad_returnredirect $redirect_url
    ad_script_abort
}

if {[exists_and_not_null event_id]} {
    element set_properties organizer_role event_id -value $event_id
    element set_properties organizer_role user_id -value ""
} elseif {[exists_and_not_null activity_id]} {
    element set_properties organizer_role activity_id -value $activity_id
}

ad_return_template

