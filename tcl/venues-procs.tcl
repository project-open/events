ad_library {

    Venue Library

    @creation-date 2002-07-23
    @author Michael Steigman (michael@steigman.net)
    @cvs-id $Id$

}

namespace eval events::venue {

    ad_proc -public new {
        {-venue_id ""}
        {-package_id ""}
        {-venue_name:required}
        {-address1 ""}
        {-address2 ""}
        {-city:required}
	{-usps_abbrev ""}
	{-postal_code ""}
	{-time_zone ""}
	{-iso ""}
        {-phone_number ""}
        {-fax_number ""}
        {-email ""}
        {-needs_reserve_p ""}
        {-max_people ""}
        {-description ""}
    } {
        create a new venue
	
	@return new venue_id
    } {
        # Prepare the variables for instantiation
        set extra_vars [ns_set create]

	set user_id [ad_conn user_id]
	set context_id [ad_conn package_id]
	set creation_ip [ad_conn peeraddr]

	db_transaction {
	    set venue_id [db_exec_plsql new_acs_venue {}]
	    
	    set extra_vars [ns_set create]
	    oacs_util::vars_to_ns_set -ns_set $extra_vars -var_list {venue_id package_id venue_name address1 address2 city usps_abbrev postal_code time_zone iso phone_number fax_number email needs_reserve_p max_people description}
	    
	    set var_list [list [list context_id [ad_conn package_id]]]

	    # Instantiate the venue	    
	    set rval [package_instantiate_object -var_list $var_list -extra_vars $extra_vars events_venue]
	}

        return $rval
    }

    ad_proc -public edit {
        {-venue_id:required}
        {-venue_name:required}
        {-address1 ""}
        {-address2 ""}
        {-city:required}
	{-usps_abbrev ""}
	{-postal_code ""}
	{-time_zone ""}
	{-iso ""}
        {-phone_number ""}
        {-fax_number ""}
        {-email ""}
        {-needs_reserve_p ""}
        {-max_people ""}
        {-description ""}
    } {
        edit a venue
    } {
	db_dml update_events_venues {}
    }

    ad_proc -public get {
        {-venue_id:required}
        {-array:required}
    } {
	<code>get</code> stuffs the following into <code><em>array</em></code>:
	<p>
	<ul>
	<li>venue_name</li>
	<li>address1</li>
	<li>address2</li>
	<li>city</li>
	<li>usps_abbrev</li>
	<li>postal_code</li>
	<li>time_zone</li>
	<li>iso</li>
	<li>phone_number</li>
	<li>fax_number</li>
	<li>email</li>
	<li>needs_reserve_p</li>
	<li>max_people</li>
	<li>description (includes direction)</li>
	</ul>
    } {
	upvar $array row
        db_1row select_venue_info {} -column_array row
    }

    ad_proc -public delete {
	{-venue_id:required}
    } {
	delete a venue
    } {
	db_exec_plsql delete_venue {}
    }

    ad_proc -public in_use_p {
	{-venue_id:required}
    } {
	is the venue being used?

	@return 1 if venue is being used by an event
    } {
	return [db_0or1row in_use_p_select {}]
    }

    ad_proc -private exists_p {
	{-venue_id:required}
    } {
	does the venue exist?

	@return 1 if venue exists
    } {
	return [db_0or1row exists_p_select {}]
    }

    ad_proc -private venues_get_options {
	{-package_id ""}
    } {
	returns a list of lists suitable for use in a form

	@return list of lists {venue_name, venue_id}
    } {
	# should filter by package_id
	return [db_list_of_lists select_venues {}]
    }

    ad_proc -private unsafe_parental_relationship_p {
	{-parent_id:required}
	{-child_id:required}
	{-package_id ""}
    } {
	will there be a safe parental relationship between this parent and child venue in this package?

	@return 1 if there will not be a safe parental relationship
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { $parent_id == $child_id } {
	    # Can't have a child of one-self
	    return 1
	} else {
	    if { [events::venue::child_of_p -parent_id $parent_id -child_id $child_id -package_id $package_id] || [events::venue::child_of_p -parent_id $child_id -child_id $parent_id -package_id $package_id] } {
		# Can't be a parent of already a child, also can't be a parent if already a parent
		return 1
	    }
	}
	return 0
    }

    ad_proc -private child_of_p {
	{-parent_id:required}
	{-child_id:required}
	{-package_id ""}
    } {
	is this child a child of this parent in this package?

	@return 1 if this child is a child of this parent
    } {
	set rval 0

	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { [db_0or1row select_parents {}] } {
	    set rval 1
	}
	return $rval
    }

    ad_proc -public make_child_of {
	{-parent_id:required}
	{-child_id:required}
	{-package_id ""}
    } {
	make this child a child of this parent for this package.
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { ![db_0or1row check_venue_one {}] || ![db_0or1row check_venue_two {}] } {
	    ad_return_complaint 1 "You must choose two valid venues to make a relationship."
	    ad_script_abort
	}

	if { ![unsafe_parental_relationship_p -parent_id $parent_id -child_id $child_id -package_id $package_id] } {
	    # It's ok to do this
	    db_dml insert_relationship {}
	} else {
	    ad_return_complaint 1 "This addition either already exists, or will cause a circular relationship, and cannot be done."
	    ad_script_abort
	}
    }

    ad_proc -private unsafe_connecting_relationship_p {
	{-left_id:required}
	{-right_id:required}
	{-package_id ""}
    } {
	will there be a safe connecting relationship between this left and right venue in this package?

	@return 1 if there will not be a safe connecting relationship
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { $left_id == $right_id } {
	    # Can't connect to one's self
	    return 1
	} else {
	    if { [events::venue::connected_p -left_id $left_id -right_id $right_id -package_id $package_id] } {
		# Can't be a left of an already right, also can't be a left if already a left
		return 1
	    }
	}
	return 0
    }

    ad_proc -private right_of_p {
	{-left_id:required}
	{-right_id:required}
	{-package_id ""}
    } {
	is this right a right of this left in this package?

	@return 1 if this right is a right of this left
    } {
	set rval 0

	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { [db_0or1row select_starting_point {}] } {
	    set rval 1
	}
	return $rval
    }

    ad_proc -public connect {
	{-left_id:required}
	{-right_id:required}
	{-package_id ""}
    } {
	connect this left and right venues together for this package.
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { ![db_0or1row check_venue_one {}] || ![db_0or1row check_venue_two {}] } {
	    ad_return_complaint 1 "You must choose two valid venues to make a relationship."
	    ad_script_abort
	}

	if { ![unsafe_connecting_relationship_p -left_id $left_id -right_id $right_id -package_id $package_id] } {
	    # It's ok to do this
	    db_dml insert_relationship {}
	} else {
	    ad_return_complaint 1 "This addition either already exists, or will cause a circular relationship, and cannot be done."
	    ad_script_abort
	}
    }

    ad_proc -public disconnect {
	{-left_id:required}
	{-right_id:required}
	{-package_id ""}
    } {
	disconnect this left venue from this right venues in this package.
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { ![db_0or1row check_venue_one {}] || ![db_0or1row check_venue_two {}] } {
	    ad_return_complaint 1 "You must choose two valid venues to remove a relationship."
	    ad_script_abort
	}

	if { [events::venue::connected_p -left_id $left_id -right_id $right_id -package_id $package_id] } {
	    # It's ok to do this
	    db_dml delete_relationship {}
	} else {
	    ad_return_complaint 1 "These venues are not connected."
	    ad_script_abort
	}
    }

    ad_proc -public connecting {
	{-venue_id:required}
	{-package_id ""}
	{-sql_p "f"}
    } {
	return any and all connecting venues or "" or NULL (if sql_p) if there aren't any.

	@return any and all connecting venues
    } {
	set rval ""

	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	db_foreach select_venues {} {
	    if { [events::venue::connected_p -left_id $venue_id -right_id $this_venue_id -package_id $package_id] } {
		if { ![empty_string_p $rval] } {
		    append rval ", "
		} else {
		    append rval " "
		}
		if { $sql_p } {
		    append rval $this_venue_id
		} else {
		    append rval $venue_name
		}
	    }
	}

	if { $sql_p && [empty_string_p $rval] } {
	    return "NULL"
	} else {
	    return $rval
	}
    }

    ad_proc -public connected_p {
	{-left_id:required}
	{-right_id:required}
	{-package_id ""}
    } {
	are these venues directly connected in this package?

	@return 1 if these venues are directly connected
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { [events::venue::right_of_p -left_id $right_id -right_id $left_id -package_id $package_id] || [events::venue::right_of_p -left_id $left_id -right_id $right_id -package_id $package_id] } {
	    # It was found
	    return 1
	} else {
	    return 0
	}
    }

    ad_proc -private parents_or_children {
	{-venue_id:required}
	{-package_id ""}
	{-parent_p "f"}
    } {
	return all initial parent or children venues or null if there aren't any.

	@return all initial parent or children venues
    } {
	set rval ""
	
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}
	
	if { $parent_p } {
	    # We want a list of parents
	    db_foreach select_parents {} {
		if { ![empty_string_p $rval] } {
		    append rval " "
		}
		append rval $venue_1
	    }
	} else {
	    # We want a list of children
	    db_foreach select_children {} {
		if { ![empty_string_p $rval] } {
		    append rval " "
		}
		append rval $venue_1
	    }
	}

	return $rval
    }

    ad_proc -public all_parents_or_children {
	{-venue_id:required}
	{-package_id ""}
	{-parent_p "f"}
	{-sql_p "f"}
    } {
	return ALL parent or children venues or null if there aren't any.

	@return any and all parent or children venues
    } {
	set list_of_children [parents_or_children -venue_id $venue_id -package_id $package_id -parent_p $parent_p]
	set rval $list_of_children
	for { set i 0 } { $i < [llength $list_of_children] } { incr i } {
	    set new_rval [all_parents_or_children -venue_id [lindex $list_of_children $i] -package_id $package_id -parent_p $parent_p -sql_p $sql_p]
	    if { ![empty_string_p $new_rval] } {
		lappend rval $new_rval
	    }
	}
	regsub -all {[{}]} $rval "" rval

	if { $sql_p } {
	    if { [empty_string_p $rval] } {
		return "NULL"
	    } else {
		regsub -all " " $rval "," rval
	    }
	}
	return $rval
    }

    ad_proc -public venues_get_connecting_options {
	{-this_venue_id:required}
	{-package_id ""}
	{-connecting "f"}
	{-none_p "t"}
    } {
	build options list for connecting venues
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	set venue_list [list]

	db_foreach select_venues {} {
	    if { $connecting } {
		if { ![events::venue::connected_p -left_id $this_venue_id -right_id $venue_id -package_id $package_id] } {
		    lappend venue_list [list $venue_name $venue_id]
		}
	    } else {
		if { [events::venue::connected_p -left_id $this_venue_id -right_id $venue_id -package_id $package_id] } {
		    lappend venue_list [list $venue_name $venue_id]
		}
	    }
	}
	if { $none_p } {
	    set venue_list [concat $venue_list {{ "None" "" }}]
	}
	return $venue_list
    }

    ad_proc -private connected {
	{-event_id:required}
	{-venue_id:required}
	{-package_id ""}
	{-sql_p "t"}
    } {
	returns list of already connected venues
    } {
	set rval ""

	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	db_foreach select_connecting {} {
	    if { $sql_p } {
		lappend rval $connected_venue_id
	    } else {
		lappend rval $connected_venue_name
	    }
	}

	if { $sql_p } {
	    if { [empty_string_p $rval] } {
		set rval "NULL"
	    } else {
		regsub -all " " $rval ", " rval
	    }
	}

	return $rval
    }

    ad_proc -public venues_get_hierarchy_options {
	{-this_venue_id:required}
	{-package_id ""}
	{-parent_p "t"}
	{-add_p "f"}
    } {
	build options list for 'parentizing' or 'childizing' venues
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	set venue_list [list]

	db_foreach select_venues {} {
	    if { $add_p } {
		if { ![events::venue::child_of_p -parent_id $this_venue_id -child_id $venue_id -package_id $package_id] && ![events::venue::child_of_p -parent_id $venue_id -child_id $this_venue_id -package_id $package_id] } {
		    lappend venue_list [list $venue_name $venue_id]
		}
	    } else {
		if { $parent_p } {
		    if { [events::venue::child_of_p -parent_id $venue_id -child_id $this_venue_id -package_id $package_id] } {
			lappend venue_list [list $venue_name $venue_id]
		    }
		} else {
		    if { [events::venue::child_of_p -parent_id $this_venue_id -child_id $venue_id -package_id $package_id] } {
			lappend venue_list [list $venue_name $venue_id]
		    }
		}
	    }
	}
	set venue_list [concat $venue_list {{ "None" "" }}]
	return $venue_list
    }

    ad_proc -public dechildize {
	{-parent_id:required}
	{-child_id:required}
	{-package_id ""}
    } {
	removes the child from this parent and fixes any subtrees accordingly
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	if { [events::venue::child_of_p -parent_id $parent_id -child_id $child_id -package_id $package_id] } {
	    db_dml delete_child {}
	}
    }

    ad_proc -public connecting_max {
	{-event_id:required}
	{-venue_id:required}
	{-package_id ""}
    } {
	if { [empty_string_p $package_id] } {
	    set package_id [ad_conn package_id]
	}

	# Connecting venues - this query must remain in the .tcl proc
	if { [db_0or1row select_connecting_max "select sum(max_people) as max from events_venues where venue_id=:venue_id or venue_id in ([events::venue::connected -event_id $event_id -venue_id $venue_id -package_id $package_id])"] } {
	    set rval $max
	}

	# Parental venues
	if { [db_0or1row select_parents {}] && ![empty_string_p $min] && $min<$rval } {
	    set rval $min
	}

	return $rval
    }

}
