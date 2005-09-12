ad_library {
    Email library

    @author Matthew Geddert (geddert@yahoo.com)
    @creation-date 2002-11-06
}

namespace eval events::email {


    ad_proc -public request_approved {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the participant a message via
        acs-mail-lite which tells them that their reservation has been approved
        and the details of their event
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info
        events::venue::get -venue_id $event_info(venue_id) -array venue_info

        set subject "Directions to $event_info(name)"

        set email_body "$reg_info(user_name),\n\n"
        append email_body "Your place is reserved for $event_info(name), which is to take place $event_info(timespan).\n\n"
        append email_body "[util_striphtml $event_info(display_after)]\n\n"
        if { ![apm_package_installed_p bulk-mail] } {
               append email_body "You'll get spammed with a reminder email a day or two before the event.\n\n"
        }
        append email_body "Venue description and directions:\n\n"
        append email_body "$venue_info(venue_name)\n"
        append email_body "$venue_info(address1)\n"
        if {[exists_and_not_null venue_info(address2)]} {       
             append message "$venue_info(address2)\n"
        }
        append email_body "$venue_info(city)  $venue_info(usps_abbrev)\n"
        append email_body "[util_striphtml $venue_info(description)]\n\n"
        if {[string compare $event_info(reg_cancellable_p) "t"] == 0} {
            append email_body "If you would like to cancel your registration, you may visit: \n"
            append email_body "$reg_info(package_url)order-check?reg_id=$reg_id"
        }        

        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)
        } else {
        # do we want a parameter for this?
            set from_addr [ad_outgoing_sender]
        }        

        # Send the email
        acs_mail_lite::send -to_addr $reg_info(user_email) \
            -from_addr $from_addr \
            -subject $subject \
            -body $email_body

            return "message sent"

    }


    ad_proc -public request_pending {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the participant a message which tells them their reservtion 
        is pending via acs-mail-lite
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        set subject "Registration Request Received"

        set email_body "$reg_info(user_name),\n\n"
        append email_body "We have recieved your request to register for $event_info(name). "
        append email_body "We will notify you shortly if your registration is approved.\n\n"
        append email_body "If you would like to cancel this request, you may visit: \n"
        append email_body "$reg_info(package_url)order-check?reg_id=$reg_id"


        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)
        } else {
        # do we want a parameter for this?
            set from_addr [ad_outgoing_sender]
        }        

        # Send the email
        acs_mail_lite::send -to_addr $reg_info(user_email) \
            -from_addr $from_addr \
            -subject $subject \
            -body $email_body
        
            return "message sent"
        
    }

    ad_proc -public request_waiting {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the participant a message via
        acs-mail-lite which tells them that they have been placed on 
        the waiting list for an event
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        set subject "Waiting list addition for $event_info(name)"

        set email_body "$reg_info(user_name),\n\n"
        append email_body "You have been placed on the waiting list for $event_info(name)\n\n"
        append email_body "We will e-mail you if a space opens up.\n\n"
        append email_body "If you would like to cancel your registration, you may visit: \n"
        append email_body "$reg_info(package_url)order-check?reg_id=$reg_id"


        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)
        } else {
        # do we want a parameter for this?
            set from_addr [ad_outgoing_sender]
        }        

        # Send the email
        acs_mail_lite::send -to_addr $reg_info(user_email) \
            -from_addr $from_addr \
            -subject $subject \
            -body $email_body
        
            return "message sent"
        
    }

    ad_proc -public request_canceled {
        {-reg_id:required}
        {-email_body:required}
    } {
	This takes a reg_id and email_body of a message and sends the participant a message via
        acs-mail-lite which tells them that their reservation has been 
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        set subject "Your registration for $event_info(name) has been canceled"

        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)
        } else {
        # do we want a parameter for this?
            set from_addr [ad_outgoing_sender]
        }        

        # Send the email
        acs_mail_lite::send -to_addr $reg_info(user_email) \
            -from_addr $from_addr \
            -subject $subject \
            -body $email_body

            return "message sent"

    }

    ad_proc -public admin_waiting {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the event admin (if he/she exists) a message via
        acs-mail-lite which tells them that this person's has automatically been placed
        on the waiting list.
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)
            
            set subject "Admin: User added to waiting list for $event_info(name)"

            set email_body "Since registration for $event_info(name) is full, "
            append email_body "$reg_info(user_name) has been placed on a waiting list. \n\n"
            append email_body "If you would like to change this persons registration, status you may visit: \n"
            append email_body "$reg_info(package_url)admin/reg-view?reg_id=$reg_id"

            # Send the email
            acs_mail_lite::send -to_addr $from_addr \
                -from_addr $from_addr \
                -subject $subject \
                -body $email_body
        }        

            return "message sent"
        
    }


    ad_proc -public admin_pending {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the event admin (if he/she exists) a message via
        acs-mail-lite which tells them that this person's registration status is waiting
        for their approval.
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)

            set subject "Admin: Approval requested for $event_info(name)"

            set email_body "Since registering for $event_info(name) requires registrations to be approved, "
            append email_body "$reg_info(user_name) has been added as a pending reservation.\n\n"
            append email_body "Please come either approve or deny $reg_info(user_name)'s request for registration:\n"
            append email_body "$reg_info(package_url)admin/reg-view?reg_id=$reg_id"

            # Send the email
            acs_mail_lite::send -to_addr $from_addr \
                -from_addr $from_addr \
                -subject $subject \
                -body $email_body
        }        

            return "message sent"
        
    }


    ad_proc -public admin_canceled {
        {-reg_id:required}
    } {
	This takes a reg_id and sends the event admin (if he/she exists) a message via
        acs-mail-lite which tells them that this person's registration status has been
        changed to canceled.
    } {
        # Get the data
        events::registration::get -reg_id $reg_id -array reg_info
        events::event::get -event_id $reg_info(event_id) -array event_info

        if {[exists_and_not_null event_info(contact_email)]} {       
            set from_addr $event_info(contact_email)

            set subject "Admin: User canceled for $event_info(name)"

            set email_body "$reg_info(user_name) has canceled his/her reservation for $event_info(name)."

            # Send the email
            acs_mail_lite::send -to_addr $from_addr \
                -from_addr $from_addr \
                -subject $subject \
                -body $email_body
        }        

            return "message sent"
        
    }



}
