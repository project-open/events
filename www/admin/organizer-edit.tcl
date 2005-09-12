#/packages/events/www/admin/organizer-edit.tcl

ad_page_contract {
    
    Edit an organizer for an event role

    @param activity_id the activity in question
    @param event_id the event in question
    @param role_id the role which we're to edit

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {role_id:naturalnum,notnull}
    {event_id:naturalnum,notnull}
    {activity_id:naturalnum,notnull}
}

events::organizer::get_role -role_id $role_id -array org_role_info

set context_bar [ad_context_bar [list "activities" "Activities"] \
	[list "activity?activity_id=$activity_id" "Activity"] \
	[list "event?event_id=$event_id" "Event"] "Edit Organizer Role"]
set title "Edit Organizer"

form create organizer_edit

element create organizer_edit activity_id \
	-datatype integer \
	-widget hidden \
	-value $activity_id

element create organizer_edit event_id \
	-datatype integer \
	-widget hidden \
	-value $event_id

element create organizer_edit role_id \
	-datatype integer \
	-widget hidden \
	-value $role_id

element create organizer_edit role \
	-label "Role" \
	-datatype text \
	-widget inform \
	-value $org_role_info(role)

element create organizer_edit user_id \
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

if {[template::form is_valid organizer_edit]} {
    template::form get_values organizer_edit user_id

    set organizer_exists_p [events::organizer::organizer_exists_p \
	    -event_id $event_id -role_id $role_id]

    if {$organizer_exists_p && [exists_and_not_null user_id]} {
	events::organizer::edit_organizer \
		-event_id $event_id \
		-role_id $role_id \
		-party_id $user_id
    } elseif {$organizer_exists_p} {
	ns_log Notice "deleting organizer"
	events::organizer::delete_organizer \
		-event_id $event_id \
		-role_id $role_id \
		-party_id $user_id
    } else {
	events::organizer::add_organizer \
		-event_id $event_id \
		-role_id $role_id \
		-party_id $user_id
    }

    ad_returnredirect "event?event_id=$event_id"
    ad_script_abort
}

element set_properties organizer_edit user_id -value $org_role_info(user_id)

ad_return_template




