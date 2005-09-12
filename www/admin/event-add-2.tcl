# events/www/admin/event-add-2.tcl

ad_page_contract {
    Purpose: allow an admin to insert info for a new event, once a
    venue has been chosen.

    @param activity_id the activity type of the new event
    @param venue_id where the new event will be located

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {activity_id:integer,notnull}
    {venue_id:integer,notnull}
}

form create event_add

element create event_add venue_id \
    -datatype integer \
    -widget hidden \
    -value $venue_id

element create event_add activity_id \
    -datatype integer \
    -widget hidden \
    -value $activity_id

element create event_add venue_name \
    -label "Location" \
    -datatype text \
    -widget inform

element create event_add event_price \
    -label "Price" \
    -datatype text \
    -widget text \
    -html {size 20} \
    -help_text "A base price, if any, for this event." \
    -optional

set ecommerce_list [db_list_of_lists ecommerce "select category_name, category_id from ec_categories order by category_name"]
set ecommerce_list [concat $ecommerce_list { { "None" "" } }]

element create event_add category_id \
    -label "Ecommerce Category" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options $ecommerce_list \
    -optional \
    -value ""

element create event_add start_time \
    -label "Start" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -minutes_interval { 0 59 5 } \
    -help

element create event_add end_time \
    -label "End" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -minutes_interval { 0 59 5 } \
    -help \
    -validate { \
    { expr {[template::util::date::compare [template::element::get_value event_add start_time] $value] < 0} } \
    {End time must be after start time} }

element create event_add reg_deadline \
    -label "Registration Deadline" \
    -datatype date \
    -widget date \
    -format "MONTH DD YYYY HH12:MI AM" \
    -minutes_interval { 0 59 5 } \
    -help \
    -help_text "at latest the Start Time" \
    -validate { \
    { expr {[template::util::date::compare $value [template::element::get_value event_add start_time]] <= 0} } \
    {Registration Deadline must be no later than the start date} }
    
element create event_add reg_cancellable_p \
    -label "Registration Cancellable?" \
    -datatype text \
    -widget select \
    -options {{Yes t} {No f}} \
    -help_text  "Can someone cancel his registration?"

element create event_add reg_needs_approval_p \
    -label "Registration Needs Approval?" \
    -datatype text \
    -widget select \
    -options {{Yes t} {No f}} \
    -help_text  "Does a registration need to be approved?"

element create event_add max_people \
    -label "Maximum Capacity" \
    -datatype text \
    -widget text \
    -html {size 20} \
    -help_text "The max number of people that can register before new registrants are automatically wait-listed.  If this field is empty, wait-listing won't automatically kick in." \
    -optional

element create event_add contact_user_id \
    -label "Event Contact Person" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::organizer::users_get_options] \
    -optional \
    -value "" \
    -search_query {
           select distinct u.first_names || ' ' || u.last_name as name, u.user_id
             from cc_users u
            where upper(decode(u.first_names,' ', '')  || decode(u.last_name,' ', '') || u.email || ' ' || decode(u.screen_name, ' ', '')) like upper('%'||:value||'%')
            order by name
}

element create event_add display_after \
    -label "Confirmation Message" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft}

element create event_add refreshments_note \
    -label "Refreshment Notes" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft} \
    -optional

element create event_add av_note \
    -label "Audio/Visual Notes" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft} \
    -optional

element create event_add additional_note \
    -label "Additional Notes" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft} \
    -optional

if {[template::form is_valid event_add]} {
    template::form get_values event_add activity_id venue_id start_time end_time reg_deadline \
	    reg_cancellable_p reg_needs_approval_p contact_user_id max_people display_after refreshments_note \
	    av_note additional_note event_price category_id
    
    events::venue::get -venue_id $venue_id -array venue_info
    events::activity::get -activity_id $activity_id -array activity_info

    set user_id [ad_conn user_id]
    set peeraddr [ns_conn peeraddr]

    db_1row select_email {}
    if { ![empty_string_p $contact_user_id] && $user_id!=$contact_user_id } {
	db_1row select_contact_email {}
	append email ", $contact_email"
    }

    db_transaction {
	
	set event_id [events::event::new -activity_id $activity_id \
			  -venue_id $venue_id \
			  -start_time $start_time \
			  -end_time $end_time \
			  -display_after $display_after \
			  -max_people $max_people \
			  -available_p "t" \
			  -deleted_p "f" \
			  -reg_deadline $reg_deadline \
			  -reg_cancellable_p $reg_cancellable_p \
			  -reg_needs_approval_p $reg_needs_approval_p \
			  -contact_user_id $contact_user_id \
			  -refreshments_note $refreshments_note \
			  -av_note $av_note \
			  -additional_note $additional_note \
			 ]
	
	if { $event_price > 0 } {	    
	    set date_time "[lindex $start_time 1]/[lindex $start_time 2]/[lindex $start_time 0]"
	    set end_date_time "[lindex $end_time 1]/[lindex $end_time 2]/[lindex $end_time 0]"
	    if { $end_date_time != $date_time } {
		set date_time "$date_time-$end_date_time"
	    }

	    set product_id [db_exec_plsql product_insert {}]

	    if { ![empty_string_p $category_id] } {
		db_dml mapping_insert {}
	    }

	    db_dml contact_update {}
	}
    }

    ad_returnredirect "event?event_id=$event_id"
}

events::activity::get -activity_id $activity_id -array activity_info
events::venue::get -venue_id $venue_id -array venue_info
set activity_name $activity_info(name)

if { [form is_request event_add] } {
    element set_properties event_add start_time -value [template::util::date::today]
    element set_properties event_add end_time -value [template::util::date::today]
    element set_properties event_add reg_deadline -value [template::util::date::today]
    element set_properties event_add display_after -value "Thanks for registering for $activity_name!"
    element set_properties event_add max_people -value $venue_info(max_people)
}

if { ![form is_valid event_add] } {
    element set_properties event_add venue_name -value $venue_info(venue_name)
}

set title "Add a New Event for $activity_name"
set context [list [list "activities" Activities] [list "activity?[export_vars { activity_id }]" $activity_info(name)] "Add Event"]
