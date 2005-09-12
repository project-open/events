# events/www/admin/send-mail.tcl

ad_page_contract {

    this page allows you to sending email in bulk to event or activity registrants, 
    it relies on the bulk-mail package

    @param activty_id
    @param event_id
    @param return_url

    @author Matthew Geddert <geddert@yahoo.com>
    @creation date 2002-11-01
    @cvs-id $Id$
} {
    {activity_id:integer,optional}
    {event_id:integer,optional}
    {group ""}
    {return_url ""}
}

# first, lets make sure they have bulk-mail installed.
if { ![apm_package_installed_p bulk-mail] } {
    ad_return_warning "Bulk-Mail is not installed" "Sending email message in bulk relies on bulk mail,
                       please see your webmaster to see if he/she can install it for you."
}

set user_id [ad_conn user_id]

if {[exists_and_not_null event_id]} {
    if {[exists_and_not_null activity_id]} {
         ad_return_warning "Both Variables Cannot Be Specified" "You must either specify Event_id or Activity_id, not both at the same time."
    }
    if { ![events::event::exists_p -event_id $event_id] } {
       ad_return_warning "Event doesn't exist" "We couldn't find the event you asked for."
    }
} else {
    if {[exists_and_not_null activity_id]} {
        if { ![events::activity::exists_p -activity_id $activity_id] } {
           ad_return_warning "Activity doesn't exist" "We couldn't find the activity you asked for."
        }
    } else {
         ad_return_warning "You must supply a variable" "You must either specify Event_id or Activity_id."
    }
}


if {[exists_and_not_null event_id]} {
    # we are sending a message to folks involved with a particular event
    events::event::get -event_id $event_id -array event_info

    set title "Send Mail to $event_info(name) [string totitle $group]"
    set context [list [list "activities" Activities] [list "activity?activity_id=$event_info(activity_id)" $event_info(name)] [list "event?event_id=$event_id" "$event_info(city)"] "Send Mail"]
    
    form create send-bulk-mail
    
    element create send-bulk-mail event_id \
	-datatype integer \
	-widget hidden \
	-value $event_id
    
    element create send-bulk-mail return_url \
	-datatype text \
	-widget hidden \
	-value $return_url
    
    db_1row select_event_from_addr_count {}
    db_1row select_my_email_address {}
    
    if { $from_addr_count == "1" } {
	
	element create send-bulk-mail from_addr \
	    -label "Send Mail From" \
	    -datatype text \
	    -widget inform \
	    -value $from_addr
	
    } else {
	
	element create send-bulk-mail from_addr \
	    -label "Send Mail From" \
	    -datatype text \
	    -widget select \
	    -options [db_list_of_lists select_event_from_addr {}] \
	    -value $from_addr
    }
    
    # LARS:
    # This is for passing on the initial 'group' page argument to the form processing
    element create send-bulk-mail group -datatype text -widget hidden

    if { [form is_valid send-bulk-mail] } {
        set group [element get_value send-bulk-mail group]
    }
    
    # are we sending mail to registrants or organizers?
    switch $group {
	registrants {
	    element create send-bulk-mail to \
		-label "Send Mail To" \
		-datatype text \
		-widget radio \
		-options { {{All Approved, Waitlisted, and Pending Registrants} all} 
		    {{Approved Registrants} approved} 
		    {{Waitlisted Registrants} waiting} 
		    {{Pending Registrants} pending} 
		} 
	}
	organizers {
	    element create send-bulk-mail to \
		-datatype text \
		-widget hidden \
		-value "organizers"
	}
    }
    
    element create send-bulk-mail subject \
	-label "Message Subject" \
	-datatype text \
	-widget text \
	-html {size 50} \
	-value "$event_info(name) on $event_info(timespan)"
    
    element create send-bulk-mail message \
	-label "Enter Message" \
	-datatype text \
	-widget textarea \
	-html {cols 60 rows 8 wrap soft}
    
    element create send-bulk-mail submit \
	-label "Send Message" \
	-datatype text \
	-widget submit      

    if { [form is_request send-bulk-mail] } {
        element set_value send-bulk-mail group $group
    }

    if {[form is_valid send-bulk-mail]} {
	form get_values send-bulk-mail event_id return_url from_addr to subject message
	
	set query ""
	
	switch $to {
	    all {
		set query [db_map select_all_event_registrants]
	    }
	    approved {
		set query [db_map select_event_reg_state_registrants]
	    }
	    waiting {
		set query [db_map select_event_reg_state_registrants]
	    }
	    pending {
		set query [db_map select_event_reg_state_registrants]
	    }
	    organizers {
		set query [db_map select_event_organizers]
	    }		
	}
	
	ns_log notice "EVENTS-MAIL-EVENT-REGS: $query"
	
      	bulk_mail::new \
      	    -from_addr $from_addr \
      	    -subject $subject \
	    -message $message \
	    -query $query 
	
	if {![exists_and_not_null return_url]} {
	    set return_url "event?event_id=$event_id"
	}        
	
	ad_returnredirect $return_url
	ad_script_abort
    }
}




if { [exists_and_not_null activity_id] } {
# we are sending a message to everybody involved with an activity
      events::activity::get -activity_id $activity_id -array activity_info

      set title "Send Mail To The $activity_info(name) Activity Registrants"
      set context [list [list "activities" Activities] [list "activity?activity_id=$activity_id" $activity_info(name)] "Send Mail"]

      form create send-bulk-mail
      
      element create send-bulk-mail activity_id \
          -datatype integer \
          -widget hidden \
          -value $activity_id
      
      element create send-bulk-mail return_url \
          -datatype text \
          -widget hidden \
          -value $return_url
      
      db_1row select_activity_from_addr_count {}
      db_1row select_my_email_address {}
      
      if {[string compare $from_addr_count "1"] == 0} {
      
           element create send-bulk-mail from_addr \
               -label "Send Mail From" \
               -datatype text \
               -widget inform \
               -value $from_addr
      
      } else {
      
           element create send-bulk-mail from_addr \
              -label "Send Mail From" \
              -datatype text \
              -widget select \
              -options [db_list_of_lists select_activity_from_addr {}] \
              -value $from_addr
      }
      
      element create send-bulk-mail to \
          -label "Send Mail To" \
          -datatype text \
          -widget radio \
          -options { {{All Approved, Waitlisted, and Pending Registrants} all} 
                     {{Approved Registrants} approved} 
                     {{Waitlisted Registrants} waiting} 
                     {{Pending Registrants} pending} 
                   } 
      
      element create send-bulk-mail time \
          -label "Registered For" \
          -datatype text \
          -widget select \
          -options { {{All Past and Future Events} all} 
                     {{Future Events} future} 
                     {{Past Events} past} 
                   } \
          -value future


      element create send-bulk-mail subject \
          -label "Message Subject" \
          -datatype text \
          -widget text \
          -html {size 50} \
          -value "$activity_info(name)"
      
      element create send-bulk-mail message \
          -label "Enter Message" \
          -datatype text \
          -widget textarea \
          -html {cols 60 rows 8 wrap soft}

      element create send-bulk-mail submit \
          -label "Send Message" \
          -datatype text \
          -widget submit      

      if {[template::form is_valid send-bulk-mail]} {
           template::form get_values send-bulk-mail activity_id return_url from_addr to time subject message
           
           set query ""

           switch $time {
                     all {
                             if {[string compare $to "all"] == 0} {
          	                set query [db_map select_activity_all_all]
                             } else {
                                set query [db_map select_activity_reg_state_all]
                             }
           	      }
                  future {
                             if {[string compare $to "all"] == 0} {
          	                set query [db_map select_activity_all_future]
                             } else {
                                set query [db_map select_activity_reg_state_future]
                             }
           	      }
                   past {
                             if {[string compare $to "all"] == 0} {
          	                set query [db_map select_activity_all_past]
                             } else {
                                set query [db_map select_activity_reg_state_past]
                             }
           	      }
           }
      
           ns_log notice "EVENTS-MAIL-ACTIVITY-REGS: $query"

           set package_id [ad_conn package_id]
      
      	bulk_mail::new \
      	    -package_id $package_id \
      	    -from_addr $from_addr \
      	    -subject $subject \
                  -message $message \
                  -query $query 
      
          if {![exists_and_not_null return_url]} {
              set return_url "activity?activity_id=$activity_id"
          }        
      
          ad_returnredirect $return_url
          ad_script_abort
      }
}
                     

ad_return_template
