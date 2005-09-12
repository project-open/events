ad_library {

    Organizer Role Library

    @creation-date 2002-07-23
    @author Michael Steigman (michael@steigman.net)
    @cvs-id $Id$

}

namespace eval events::organizer {

    ad_proc -public new_role {
        {-activity_id ""}
        {-event_id ""}
	{-role ""}
	{-responsibilities ""}
	{-public_role_p ""}
	{-user_id ""}
    } {
        create new organizer role; returns role_id
    } {
	set role_id [db_nextval events_org_roles_seq]
        db_dml new_org_role {}
	return $role_id
    }
    
    ad_proc -public get_role {
        {-role_id:required}
        {-array:required}
    } {
        retrieve an organizer role
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row
        db_1row select_org_role_info {} -column_array row
    }

    ad_proc -public edit_role {
        {-role_id:required}
        {-role ""}
        {-responsibilities ""}
	{-public_role_p ""}
    } {
        edit an organizer role
    } {
        db_dml edit_org_role {}
    }

    ad_proc -public delete_role {
        {-role_id:required}
    } {
        remove org role from system
    } {
        db_dml delete_org_role {}
    }

    ad_proc -public map_role {
	{-role_id ""}
	{-role_id_list ""}
	{-activity_id ""}
	{-event_id ""}
    } {
	map a role (or roles) to an activity or an event
    } {
	if {[exists_and_not_null event_id]} {
	    db_dml insert_into_events_org_role_event_map {}
	} else {
	    db_dml insert_into_events_org_role_activity_map {}
	}
    }

    ad_proc -public unmap_role {
	{-role_id ""}
	{-role_id_list ""}
	{-activity_id ""}
	{-event_id ""}
    } {
	unmap a role (or roles) from an activity or an event
    } {
	if {[exists_and_not_null event_id]} {
	    db_dml delete_from_events_organizers_map {}
	    db_dml delete_from_events_org_role_event_map {}
	} else {
	    db_dml delete_from_events_org_role_activity_map {}
	}
    }

    ad_proc -public add_organizer {
	{-role_id:required}
	{-party_id:required}
	{-event_id:required}
    } {
	add an organizer in a role
    } {
	db_dml insert_into_events_organizers_map {}
    }

    ad_proc -public edit_organizer {
	{-role_id:required}
	{-party_id:required}
	{-event_id:required}
    } {
	edit an organizer in a role
    } {
	db_dml update_events_organizers_map {}
    }

    ad_proc -public delete_organizer {
	{-role_id:required}
	{-party_id:required}
	{-event_id:required}
    } {
	delete an organizer from a role
    } {
	db_dml delete_from_events_organizers_map {}
    }

    ad_proc users_get_options {
	{-package_id ""}
    } {
	build options list for contacts
    } {
	set users_list [db_list_of_lists users {}]
	set users_list [concat $users_list { { "None" "" } } { { "Search for a user..." ":search:" } }]
	return $users_list
    }

    ad_proc -private organizer_exists_p {
        {-role_id:required}
        {-event_id:required}
    } {
	is there an organizer for this role_id/event_id? we're not worried about
	being smart enough to check for an exact match - if there's an organizer
	in this role, we'll update (need to change logic to support many-to-one
	organizer relationship)
    } {
	return [db_0or1row check_events_organizers_map {}]
    }

}
