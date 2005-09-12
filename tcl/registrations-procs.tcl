ad_library {

    Registrations Library

    @creation-date 2002-08-24
    @modified Matthew Geddert (geddert@yahoo.com)
    @author Michael Steigman (michael@steigman.net)
    @cvs-id $Id$

}

namespace eval events::registration {

    ad_proc -public new {
	{-reg_id ""}
	{-event_id:required}
        {-user_id:required}
	{-comments ""}
    } {
        create a new registration
    } {
        # check what reg state this user will get
        events::event::get -event_id $event_id -array event_info
        # first we check if the registration needs approval
        if {[string compare $event_info(reg_needs_approval_p) "t"] == 0} {
             set reg_state "pending"       
        } else {
        # it doesn't need approval, so we need to check if they will automatically be waitlisted
              events::event::get_stats -event_id $event_id -array event_stats
              if { ![empty_string_p $event_stats(max_people)] && ( 0 >= [expr $event_stats(max_people) - $event_stats(approved)] || $event_stats(waiting) > 0 ) } {
              # there are no more spots available
                  set reg_state "waiting"
              } else {
              # there are spots left
                  set reg_state "approved"

              }
        } 

        # Prepare the variables for instantiation
        set extra_vars [ns_set create]
        oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list \
		{reg_id event_id user_id reg_state comments}

        # Instantiate the registration, if one doesn't already exist
	set new_reg_id [events::registration::exists_for_activity_p -user_id $user_id -event_id $event_id]
	if { $new_reg_id==0 } {
	    set new_reg_id [package_instantiate_object -extra_vars $extra_vars events_registration]
	} else {
	    db_dml update_registration "update events_registrations set reg_state=:reg_state where reg_id=:new_reg_id"
	}

        if {[string compare $reg_state "approved"] == 0} {
           events::email::request_approved -reg_id $new_reg_id
        } 

        if {[string compare $reg_state "pending"] == 0} {
           events::email::request_pending -reg_id $new_reg_id
           events::email::admin_pending -reg_id $new_reg_id
        }
 
        if {[string compare $reg_state "waiting"] == 0} {
           events::email::request_waiting -reg_id $new_reg_id
           events::email::admin_waiting -reg_id $new_reg_id
        }        

        return $new_reg_id
    }

    ad_proc -public get {
	{-reg_id:required}
	{-array:required}
    } {
	<code>get</code> stuffs the following into <code><em>array</em></code>:
	<ul>
          <li>event_id</li>
          <li>user_id<li>
	  <li>user_name</li>
	  <li>user_email</li>
	  <li>reg_state</li>
	  <li>creation_date</li>
	  <li>approval_date</li>
	  <li>comments</li>
          <li>package_url (includes the system url and site node url used for emailing - i.e. http://system_url/package_url/)</li>
	</ul>
    } {
        # Select the info into the upvar'ed Tcl Array
        set date_format [parameter::get -parameter date_format]
        set time_format [parameter::get -parameter time_format]
        set package_id [ad_conn package_id]
        set url [ad_url]

        upvar $array row
        db_1row select_registration_info {} -column_array row
    }

    ad_proc -public cancel {
	{-reg_id:required}
        {-email_body:required}
    } {
        cancel a registration
    } {
        db_dml cancel_registration {}
        events::email::request_canceled -reg_id $reg_id -email_body $email_body

        return $reg_id
    }

    ad_proc -public approve {
	{-reg_id:required}
    } {
        cancel a registration
    } {
        db_dml approve_registration {}
        events::email::request_approved -reg_id $reg_id

        return $reg_id
    }

    ad_proc -public waiting {
	{-reg_id:required}
    } {
        cancel a registration
    } {
        db_dml waiting_registration {}
        events::email::request_waiting -reg_id $reg_id

        return $reg_id
    }

    ad_proc -private exists_p {
	{-reg_id:required}
    } {
	does the registration exist as part of this package instance?
	
	@return 1 if event exists
    } {
        set package_id [ad_conn package_id]
	return [db_0or1row exists_p_select {}]
    }

    ad_proc -public edit_reg_comments {
	{-reg_id:required}
	{-comments:required}
    } {
	edit a registration comments
    } {
	db_dml edit_reg_comments {}
    }

    ad_proc -private exists_for_activity_p {
	{-user_id:required}
	{-event_id:required}
    } {
	does a registration for this user exist for this event?
	
	@return 0 if registration doesn't exist, else return reg_id
    } {
	if { [db_0or1row exists_for_activity_p_select "select reg_id from events_registrations where event_id=:event_id and user_id=:user_id"] } {
	    return $reg_id
	} else {
	    return 0
	}
    }

#    ad_proc -public edit {
#	{-reg_id:required}
#	{-party_id:required}
#	{-reg_state:required}
#    } {
#	edit a registration
#    } {
#	db_dml edit_registration {}
#    }
#
#    ad_proc -public delete {
#	{-reg_id:required}
#    } {
#	delete a registration
#    } {
#	db_exec_plsql delete_registration {}
#    }
#
#    ad_proc -public new_attribute {
#        {-attribute_name:required}
#        {-after ""}
#        {-pretty_name:required}
#        {-pretty_plural ""}
#        {-datatype:required}
#        {-category_id:required}
#    } {
#        create a registration attribute
#
#	@return attribute_id
#    } {
#	set sort_order [events::registration::get_sort_order $category_id]
#	set attribute_id [db_exec_plsql create_reg_attribute {}]
#	db_dml insert_into_events_attr_category_map {}
#	return $attribute_id
#    }
#
#    ad_proc -public get_attribute {
#	{-attribute_id:required}
#	{-array:required}
#    } {
#	get attribute info
#    } {
#        # Select the info into the upvar'ed Tcl Array
#        upvar $array row
#        db_1row select_attribute_info {} -column_array row
#    }
#
#    ad_proc -public edit_attribute {
#        {-attribute_id:required}
#        {-attribute_name:required}
#        {-pretty_name:required}
#        {-pretty_plural ""}
#        {-datatype:required}
#        {-category_id:required}
#    } {
#        edit a registration attribute
#    } {
#	db_dml edit_reg_attribute {}
#	db_dml edit_reg_attr_category {}
#    }
#
#    ad_proc -public delete_attribute {
#        {-attribute_name:required}
#        {-attribute_id:required}
#    } {
#        delete a registration attribute
#    } {
#	db_dml del_from_events_attr_category_map {}
#	db_exec_plsql drop_reg_attribute {}
#    }
#
#    ad_proc -public map_attribute {
#        {-activity_id ""}
#        {-event_id ""}
#        {-attribute_id ""}
#        {-attribute_id_list ""}
#    } {
#	map an attribute (or attributes) to an activity/event 
#    } {
#	if {[exists_and_not_null event_id]} {
#	    db_dml insert_into_events_event_attr_map {}
#	} else {
#	    db_dml insert_into_events_def_actvty_attr_map {}
#	}
#    }
#
#    ad_proc -public unmap_attribute {
#	{-attribute_id:required}
#        {-activity_id ""}
#        {-event_id ""}
#        {-attribute_id_list ""}
#    } {
#	unmap an attribute (or attributes) from an activity/event
#
#	@param attribute_id attribute_id to unmap
#    } {
#	if {[exists_and_not_null event_id]} {
#	    db_dml delete_from_events_event_attr_map {}
#	} else {
#	    db_dml delete_from_events_def_actvty_attr_map {}
#	}
#    }
#
#    ad_proc -private get_sort_order {
#        { category_id }
#    } {
#        helper proc to get the sort_order for a new registration attribute
#
#	@param category_id category for which we're finding sort_order + 1
#
#	@author Michael Steigman (michael@steigman.net)
#    } {
#	db_1row get_sort_order_max {}
#	return [expr $sort_order_max + 1]
#    }
}

