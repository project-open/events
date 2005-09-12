ad_library {

    Activity Library

    @creation-date 2002-07-23
    @author Michael Steigman (michael@steigman.net)
    @cvs-id $Id$

}

namespace eval events::activity {

    ad_proc -public new {
        {-activity_id ""}
        {-package_id:required}
        {-name:required}
        {-detail_url ""}
        {-default_contact_user_id ""}
        {-description ""}
    } {
        create a new activity
    } {
        # Prepare the variables for instantiation
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list \
		{activity_id package_id name detail_url default_contact_user_id description}

	set var_list [list [list context_id $package_id]]

        # Instantiate the activity
        return [package_instantiate_object -var_list $var_list -extra_vars $extra_vars events_activity]
    }

    ad_proc -public edit {
        {-activity_id ""}
        {-name:required}
        {-detail_url:required}
        {-description ""}
	{-html_p ""}
	{-available_p ""}
	{-default_contact_user_id ""}

    } {
        edit an activity
    } {
        # Need to update 2 tables
        db_dml update_acs_activities {}
        db_dml update_events_activities {}
    }

    ad_proc -public get {
        {-activity_id:required}
        {-array:required}
    } {
        <code>get</code> stuffs the following into <code><em>array</em></code>:
	<ul>
	<li>name</li>
	<li>description</li>
	<li>available_p</li>
	<li>detail_url</li>
	<li>default_contact_user_id</li>
	<li>default_contact_email</li>
	<li>default_contact_name</li>
	</ul>
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row
        db_1row select_activity_info {} -column_array row
    }

    ad_proc -public get_creator {
	{-activity_id:required}
	{-array:required}
    } {
	get creator name and email
    } {
        upvar $array row
        db_1row select_creator_info {} -column_array row
    }

    ad_proc -public get_stats {
	{-activity_id:required}
	{-array:required}
    } {
	<code>get</code> stuffs the following into <code><em>array</em></code>:
	<ul>
	<li>approved</li>
	<li>pending</li>
	<li>waiting</li>
	<li>canceled</li>
	</ul>
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row
        db_1row select_activity_stats {} -column_array row
    }

    ad_proc -public delete {
	{-activity_id:required}
    } {
	delete an activity
    } {
	db_exec_plsql delete_activity {}
    }

    ad_proc -private exists_p {
	{-activity_id:required}
    } {
	does the activity exist in this package instance?
	
	@return 1 if activity exists
    } {
        set package_id [ad_conn package_id]
	return [db_0or1row exists_p_select {}]
    }

}
