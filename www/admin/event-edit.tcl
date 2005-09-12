# events/www/admin/event-edit.tcl

ad_page_contract {
    Allows admins to edit an event's properties.
    Provides a form with existing data filled in.

    @param event_id the event to edit
    @param venue_id the event's new venue (if changing the venue)
    @param user_id_from_search optional new contact person's user_id
    @param email_from_search optional new contact person's email

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {event_id:integer,notnull}
    {venue_id:integer,optional}
} -validate {
    event_exists_p -requires {event_id} { 
	if { ![events::event::exists_p -event_id $event_id] } {
	    ad_complain "We couldn't find the event you asked for."
	    return 0
	}
	return 1
    }
}

set user_id [ad_conn user_id]

events::event::get -event_id $event_id -array event_info
events::event::get_stats -event_id $event_id -array stat_info

set admin_text ""
if { ![db_0or1row select_ecommerce_info {}] } {
    set category_id ""
    set price ""
} else {
    if { ![empty_string_p $sale_price] && $sale_price < $price } {
	set price $sale_price
    }
    # If admin
    if { [permission::permission_p -no_cache -party_id $user_id -object_id $event_id -privilege "admin"] } {
	set admin_text "<br><center>(<a href=\"[apm_package_url_from_key "ecommerce"]admin/products/edit?product_id=$product_id\" target=\"_blank\">edit user class prices</a>)</center>"
    }
}

form create event_edit

element create event_edit event_id \
    -datatype integer \
    -widget hidden

element create event_edit action \
    -label "Action" \
    -datatype text \
    -widget inform

element create event_edit venue_id \
    -label "Venue" \
    -datatype integer \
    -widget select \
    -options [events::venue::venues_get_options]

set venues_connecting [events::venue::venues_get_connecting_options -this_venue_id $event_info(venue_id) -none_p "f"]
if { ![empty_string_p $venues_connecting] } {
    element create event_edit event_connecting \
    -label "Use Connecting" \
    -datatype text \
    -widget checkbox \
    -help_text "Use the following connecting venues" \
    -options $venues_connecting \
    -optional
} else {
    element create event_edit event_connecting \
    -optional \
    -widget hidden
}

element create event_edit event_price \
    -label "Price" \
    -datatype text \
    -widget text \
    -html {size 20} \
    -help_text "A base price, if any, for this event.$admin_text" \
    -optional

set ecommerce_list [db_list_of_lists ecommerce "select category_name, category_id from ec_categories order by category_name"]
set ecommerce_list [concat $ecommerce_list { { "None" "" } }]

element create event_edit category_id \
    -label "Ecommerce Category" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options $ecommerce_list \
    -optional

element create event_edit max_people \
    -label "Maximum Capacity" \
    -datatype text \
    -widget text \
    -html {size 20} \
    -optional

element create event_edit reg_cancellable_p \
    -label "Registration Cancellable?" \
    -datatype text \
    -widget select \
    -options {{Yes t} {No f}} \
    -help_text  "Can someone cancel his registration?"

element create event_edit reg_needs_approval_p \
    -label "Registration Needs Approval?" \
    -datatype text \
    -widget select \
    -options {{Yes t} {No f}} \
    -help_text  "Does a registration need to be approved?"

element create event_edit contact_user_id \
    -label "Event Contact Person" \
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

element create event_edit display_after \
    -label "Confirmation Message" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft}

element create event_edit start_time \
    -label "Start" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -help

element create event_edit time_zone \
    -label "Timezone" \
    -datatype string \
    -widget text \
    -help

element create event_edit end_time \
    -label "End" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -help \
    -validate { \
    { expr {[template::util::date::compare [template::element::get_value event_edit start_time] $value] < 0} } \
    {End time must be after start time} }

element create event_edit reg_deadline \
    -label "Registration Deadline" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -help \
    -help_text "at latest the Start Time" \
    -validate { \
    { expr {[template::util::date::compare $value [template::element::get_value event_edit start_time]] <= 0} } \
    {Registration Deadline must be no later than the start date} }    

events::activity::get -activity_id $event_info(activity_id) -array activity_info

if {[template::form is_valid event_edit]} {
    template::form get_values event_edit event_id venue_id max_people \
	    reg_cancellable_p reg_needs_approval_p contact_user_id \
	    display_after time_zone start_time end_time reg_deadline event_price category_id

    set event_connecting [template::element get_values event_edit event_connecting]

    events::venue::get -venue_id $venue_id -array venue_info

    set peeraddr [ns_conn peeraddr]

    db_1row select_email {}
    if { ![empty_string_p $contact_user_id] && $user_id!=$contact_user_id } {
	db_1row select_contact_email {}
	append email ", $contact_email"
    }

    set pretty_location ""
    if { ![empty_string_p $event_info(city)] } {
	append pretty_location "$event_info(city)"
    }
    if { ![empty_string_p $event_info(usps_abbrev)] } {
	if { ![empty_string_p $event_info(city)] } {
	    append pretty_location ", "
	}
	append pretty_location "$event_info(usps_abbrev)"
    }

    db_transaction {

	if { ![db_0or1row select_product_id {}] } {
	    set product_id ""
	}

	db_dml mapping_remove {}

	# Update connecting venues
	db_dml delete_connecting {}
	for { set i 0 } { $i < [llength $event_connecting] } { incr i } {
	    set connecting_venue_id [lindex $event_connecting $i]
	    if { ![empty_string_p $connecting_venue_id] && [db_0or1row valid_venue {}] } {
		db_dml insert_connecting {}
	    }
	}

	set venue [events::venue::connected -event_id $event_id -venue_id $venue_id -sql_p "f"]
	for { set i 0 } { $i < [llength $venue] } { incr i } {
	    append venue_info(venue_name) ", [lindex $venue $i]"
	}

	if { $event_price > 0 } {	    
	    set date_time "[lindex $start_time 1]/[lindex $start_time 2]/[lindex $start_time 0]"
	    set end_date_time "[lindex $end_time 1]/[lindex $end_time 2]/[lindex $end_time 0]"
	    if { $end_date_time != $date_time } {
		set date_time "$date_time-$end_date_time"
	    }
		
	    if { ![empty_string_p $product_id] } {

		set audit_update [db_map audit_update_sql]
		
		db_dml product_update {}
	       
	    } else {
		set product_id [db_exec_plsql product_insert {}]
		
		db_dml contact_update {}
	    }

	    if { ![empty_string_p $category_id] } {
		# insert category map
		db_dml mapping_insert {}
	    }
	} else {
	    # Remove this event from ecommerce
	    db_exec_plsql product_delete {}
	}

	if { ![empty_string_p $max_people] && (([expr [expr $stat_info(approved) + $stat_info(pending)] + $stat_info(waiting)] > $max_people) || [events::venue::connecting_max -event_id $event_id -venue_id $venue_id]<$max_people) } {
	    ad_return_complaint 1 "You cannot have more registrants than your Venue Capacity."
	    ad_script_abort
	}

	# We've made it this far.  Do the update.
	events::event::edit \
	    -event_id $event_id \
	    -venue_id $venue_id \
	    -max_people $max_people \
	    -reg_cancellable_p $reg_cancellable_p \
	    -reg_needs_approval_p $reg_needs_approval_p \
	    -contact_user_id $contact_user_id \
	    -display_after $display_after \
	    -start_time $start_time \
	    -end_time $end_time \
	    -reg_deadline $reg_deadline

	db_dml update_timezone "
		update events_events
		set time_zone=:time_zone
		where event_id = :event_id
	"

    }

    ad_returnredirect "event?event_id=$event_id"
    ad_script_abort
}

# Slug form with any/all connected venues to this event ...
set connected_venue_list ""
for { set i 0 } { $i < [llength $venues_connecting] } { incr i } {
    set venue_id [lindex [lindex $venues_connecting $i] 1]
    if { [db_0or1row select_connecting {}] } {
	lappend connected_venue_list $venue_id
    }
}
element set_properties event_edit event_connecting -values $connected_venue_list

element set_properties event_edit action -value "Edit $event_info(name) on $event_info(timespan)"
element set_properties event_edit event_id -value $event_id

if { [form is_request event_edit] } {
    element set_properties event_edit venue_id -value $event_info(venue_id)
    element set_properties event_edit event_price -value $price
    element set_properties event_edit time_zone -value [string trim $event_info(time_zone)]
    element set_properties event_edit category_id -value $category_id
    element set_properties event_edit max_people -value $event_info(max_people)
    element set_properties event_edit reg_cancellable_p -value $event_info(reg_cancellable_p)
    element set_properties event_edit reg_needs_approval_p -value $event_info(reg_needs_approval_p)
    element set_properties event_edit contact_user_id -value $event_info(contact_user_id)
    element set_properties event_edit display_after -value $event_info(display_after)
    element set_properties event_edit start_time -value [events::event::make_event_date \
                                                             -which_type start_time -timespan_id $event_info(timespan_id)]
    element set_properties event_edit end_time -value [events::event::make_event_date \
                                                           -which_type end_time -timespan_id $event_info(timespan_id)]
    element set_properties event_edit reg_deadline -value [events::event::make_event_date \
                                                               -which_type reg_deadline -event_id $event_id]
}

set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$event_info(activity_id)" $activity_info(name)] [list "event?event_id=$event_id" $event_info(city)] "Edit"]
set return_url "event-edit.tcl?event_id=$event_id"
set title "Edit Event"

ad_return_template
