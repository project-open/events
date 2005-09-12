ad_library {

    Events Library

    @creation-date 2002-07-23
    @author Michael Steigman (michael@steigman.net)
    @cvs-id $Id$

}

namespace eval events::event {

    ad_proc -public new {
        {-activity_id:required}
	{-venue_id:required}
        {-display_after ""}
        {-max_people ""}
	{-start_time:required}
	{-end_time:required}
	{-reg_deadline:required}
	{-available_p "t"}
	{-deleted_p "f"}
        {-reg_cancellable_p ""}
        {-reg_needs_approval_p ""}
	{-contact_user_id ""}
        {-refreshments_note ""}
        {-av_note ""}
        {-additional_note ""}
        {-alternative_reg ""}
    } {
        create a new event based on activity_id
    } {


         set sql_start_date [events::time::to_sql_datetime -datetime $start_time]
         set sql_end_date [events::time::to_sql_datetime -datetime $end_time]
         set sql_reg_deadline [events::time::to_sql_datetime -datetime $reg_deadline]

# these are replaced by the events::time procs
#	set sql_start_date [template::util::date::get_property linear_date $start_time]
#	set sql_end_date [template::util::date::get_property linear_date $end_time]
#	set sql_reg_deadline [template::util::date::get_property linear_date $reg_deadline]

        # oracle needs date_format to take the sql dates
        set date_format "YYYY MM DD HH24 MI SS"

        set timespan_id [db_exec_plsql new_timespan {}]

	# Should be moved to calling pages and sent via arguments?
	# don't think we want to deal with connection stuff here
	set creation_user [ad_conn user_id]
	set creation_ip [ad_conn peeraddr]
        set context_id $activity_id
	set event_id [db_exec_plsql new_acs_event {}]
	db_exec_plsql new_event {}

        events::event::verify_bulk_mail_reminder -event_id $event_id
	return $event_id
    }

    ad_proc -public edit {
        {-event_id:required}
	{-venue_id:required}
        {-max_people ""}
        {-reg_cancellable_p ""}
        {-reg_needs_approval_p ""}
	{-contact_user_id ""}
        {-display_after ""}
	{-start_time:required}
	{-end_time:required}
	{-reg_deadline:required}
    } {
        edit an event
    } {
	set date_format "YYYY MM DD HH24 MI SS"
        set sql_reg_deadline [events::time::to_sql_datetime -datetime $reg_deadline]
#	set sql_reg_deadline [template::util::date::get_property linear_date $reg_deadline]
        db_dml update_event {}

	set interval_id [db_string select_interval_id {}]
        set sql_start_date [events::time::to_sql_datetime -datetime $start_time]
        set sql_end_date [events::time::to_sql_datetime -datetime $end_time]
#	set sql_start_date [template::util::date::get_property linear_date $start_time]
#	set sql_end_date [template::util::date::get_property linear_date $end_time]
        db_dml update_time_interval {}
        events::event::verify_bulk_mail_reminder -event_id $event_id
    }

    ad_proc -public edit_event_notes {
        {-event_id:required}
	{-refreshments_note ""}
	{-av_note ""}
	{-additional_note ""}
    } {
        edit event notes
    } {
        db_dml update_event_notes {}
    }

    ad_proc -public get {
	{-event_id:required}
	{-array:required}
    } {
	<code>get</code> stuffs the following into <code><em>array</em></code>:
	<ul>
	<li>activity_id</li>
	<li>name</li>
	<li>description</li>
	<li>display_after</li>
	<li>city</li>
	<li>usps_abbrev</li>
	<li>venue_id</li>
	<li>timespan (in format specified in parameters)</li>
	<li>reg_deadline (in format specified in parameters)</li>
	<li>available_p</li>
	<li>max_people</li>
	<li>refreshments_note</li>
	<li>av_note</li>
	<li>additional_note</li>
	<li>timespan_id</li>
	<li>reg_cancellable_p (t or f)</li>
	<li>reg_needs_approval_p (t or f)</li>
	<li>pretty_reg_cancellable_p (Yes or No)</li>
	<li>pretty_reg_needs_approval_p (Yes or No)</li>
	<li>contact_email</li>
	</ul>
    } {
        # Select the info into the upvar'ed Tcl Array
	set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
	set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

        upvar $array row
        db_1row select_event_info {} -column_array row

	# Venue(s)
	set max [events::venue::connecting_max -event_id $event_id -venue_id $row(venue_id) -package_id [ad_conn package_id]]
	if { [empty_string_p $row(max_people)] && ![empty_string_p $max] } {
	    set row(max_people) $max
	}
    }

    ad_proc -public get_creator {
	{-event_id:required}
	{-array:required}
    } {
	get creator name and email
    } {
        upvar $array row
        db_1row select_creator_info {} -column_array row
    }

    ad_proc -public get_stats {
	{-event_id:required}
	{-array:required}
    } {
	<code>get</code> stuffs the following into <code><em>array</em></code>:
	<ul>
	<li>total_interested (the number of people approved, pending, and waiting)</li>
        <li>max_people</li>
	<li>approved</li>
	<li>pending</li>
	<li>waiting</li>
	<li>canceled</li>
	<li>venue_id</li>
	</ul>
    } {
        # Select the info into the upvar'ed Tcl Array
        upvar $array row
        db_1row select_event_stats {} -column_array row

	# Venue(s)
	set max [events::venue::connecting_max -event_id $event_id -venue_id $row(venue_id) -package_id [ad_conn package_id]]
	if { [empty_string_p $row(max_people)] && ![empty_string_p $max] } {
	    set row(max_people) $max
	}
    }

    ad_proc -public delete {
	{-event_id:required}
    } {
	delete an event
    } {
	db_exec_plsql delete_event {}
    }

    ad_proc -private make_event_date {
	{-which_type:required}
	{-timespan_id ""}
	{-event_id ""}
    } {
	return a templating date type suitable for use with forms.
	timespan_id is necessary to make start_time and end_time, 
	event_id is necessary to make reg_deadline.
    } {
	set date_format "YYYY MM DD HH24 MI"
	switch $which_type {
	    start_time {
		set which_date "t.start_date"
		set raw_date [db_string select_event_date {}]
	    }
	    end_time {
		set which_date "t.end_date"
		set raw_date [db_string select_event_date {}]
	    }
	    reg_deadline {
		set raw_date [db_string select_reg_deadline {}]
	    }
	}

	return [template::util::date::create \
		    [lindex $raw_date 0] \
		    [lindex $raw_date 1] \
		    [lindex $raw_date 2] \
		    [lindex $raw_date 3] \
		    [lindex $raw_date 4] \
		    $date_format \
		   ]
    }

    ad_proc -public toggle_available_p {
	{-event_id:required}
    } {
	toggle event availability
    } {
	db_dml toggle {}
    }

    ad_proc -public attachments_enabled_p {
    } {
	are attachments configured?

	attachments require the attachment package mounted
	under events (as attach) and a row in the attachments_fs_root_folder_map
	with the events package_id and the desired fs instance root 
	folder
    } {
	set package_id [ad_conn package_id]
        if {[site_node_apm_integration::child_package_exists_p -package_key attachments] && \
		[db_0or1row root_folder_exists_p {}] } {
	    return 1
	} else {
	    return 0
	}
	
    }

    ad_proc -private exists_p {
	{-event_id:required}
    } {
	does the event exist as part of this package instance?
	
	@return 1 if event exists
    } {
        set package_id [ad_conn package_id]
	return [db_0or1row exists_p_select {}]
    }

    ad_proc -private reg_deadline_elapsed_p {
	{-event_id:required}
    } {
	has the reg deadline elapsed
	
	@return 1 if event exists
    } {
	return [db_0or1row reg_deadline_elapsed_p_select {}]
    }



    ad_proc -private verify_bulk_mail_reminder {
	{-event_id:required}
    } {
	if bulk mail is installed, this proc will check if 
        the given event has a bulk mail email reminder, if it 
        does it will make update the send date to fit any changes 
        in an events start date, if none exists, then it will 
        create such a reminder. The reason this isn't broken
        into two different procs is because some people might
        choose to install bulk mail after some events have already
        been created, then if they update an event it will automatically
        create a reminder email for that events registrants
	
        @param event_id
	@return 1 if compelete successfully 0 if bulk mail is not installed
    } {

        # first, lets make sure they have bulk-mail installed.
        if { ![apm_package_installed_p bulk-mail] } {
            return 0
        } else {
        
                
                # first we see whether or not a bulk mail message has already been
                # created. we do this by seeing if the bulk_mail_id column of the
                # events_events table has an associated bulk mail message with it
                # while we are at it we will also pull out the event's start date
                # in the format we want to determine a bulk mail send_date
                # which is two days prior to the events start date
                
                db_1row select_startdate_and_bulk_mail_id {}
                
                # this is ugly, but it seems to work.
                # in order to manipulate the day of the year we need to remove leading zeros
                # to do this i will search for a string at the beginning to see there are 
                # leading zeros
                set day_of_year [string trim $day_of_year]
                set day_of_year " $day_of_year "
                # if there is a leading zero append START to the front and END to the back
                regsub -nocase -all {([^a-zA-Z0-9]+)(0[^\(\)<>\s]+)} $day_of_year "\\1\tSTART\\2END\t" day_of_year
                # remove 2 leading zero's if they exist
                regsub -all {\tSTART00([^\t]*)END\t} $day_of_year {\1} day_of_year
                # remove 1 leading zero if it exists
                regsub -all {\tSTART0([^\t]*)END\t} $day_of_year {\1} day_of_year
                set day_of_year [string trim $day_of_year]
                                                          
                set two_days_ago [expr $day_of_year - 2]
                set year_two_days_ago $year
                if { $two_days_ago <= 0 } {
                     set year_two_days_ago [expr $year -1]
                # this isn't taking leap years with 366 days into acocunt - but i think it is close enough
                # so once every 4 years for events on jan 1 and 2 the reminder will be three days before
                # the event and not two
                     set two_days_ago [expr 365 + $two_days_ago]
                }

                # although this works with regular updates, it isn't working with bulk_mail::new so i need
                # to go to the database to format this in a way postgresql will like i.e. 'YYYY-MM-DD HH24:MI:SS'
                set bulk_mail_send_date "$two_days_ago $year_two_days_ago $time"

                db_1row convert_to_timestamp_the_db_likes {}
                set bulk_mail_date_format "YYYY-MM-DD HH24:MI:SS"
        
                # now lets create the email message we want to send
                events::event::get -event_id $event_id -array event_info
                events::venue::get -venue_id $event_info(venue_id) -array venue_info
        
                if {[exists_and_not_null event_info(contact_email)]} {       
                    set from_addr $event_info(contact_email)
                } else {
                # do we want a parameter for this?
                    set from_addr [ad_outgoing_sender]
                }        
        
                set subject "Reminder: $event_info(name) - $event_info(timespan)."
        
                set message "This is a reminder to all registered users for $event_info(name), "
                append message "that the event is going to take place $event_info(timespan).\n\n"
                append message "Once again, here is the venue description and directions:\n\n"
                append message "$venue_info(venue_name)\n"
                append message "$venue_info(address1)\n"
                if {[exists_and_not_null venue_info(address2)]} {       
                     append message "$venue_info(address2)\n"
                }
                append message "$venue_info(city)  $venue_info(usps_abbrev)\n"
                append message "[util_striphtml $venue_info(description)]\n\n"
                      
                if {[exists_and_not_null bulk_mail_id]} {
                        db_dml update_bulk_mail {}
                } else {
                # there is no bulk mail reminder so we need to create one
         
                        set query [db_map select_approved_registrants]
              
			if { [db_0or1row check_email_list [db_map check_emails]] } {
			    set bulk_mail_id [bulk_mail::new -from_addr $from_addr -send_date $bulk_mail_send_date -date_format $bulk_mail_date_format -subject $subject -message $message -query $query]
			    db_dml update_events_events_bulk_mail_id {}
			}
                    }
        	return 1
            }
     }
}