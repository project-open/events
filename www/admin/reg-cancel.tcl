# events/www/admin/reg-cancel.tcl
ad_page_contract {

    Cancel a Registration.

    @param  reg_id the registration to cancel

    @author Matthew Geddert (geddert@yahoo.com)
    @creation date 2002-11-11

} {
    {reg_id:naturalnum,notnull}
    {return_url ""}
} -validate {
    registration_exists_p -requires {reg_id} { 
	if { ![events::registration::exists_p -reg_id $reg_id] } {
	    ad_complain "We could not find the registration you asked for."
	    return 0
	}
	return 1
    }
}

events::registration::get -reg_id $reg_id -array reg_info
events::event::get -event_id $reg_info(event_id) -array event_info
events::venue::get -venue_id $event_info(venue_id) -array venue_info

set title "Cancel $reg_info(user_name)'s Registration"
set context [list [list "event?event_id=$reg_info(event_id)" "$event_info(name) in $venue_info(city)"] "Cancel $reg_info(user_name)'s Registration"]

form create confirm_cancel

element create confirm_cancel return_url \
    -datatype text \
    -widget hidden \
    -value $return_url

element create confirm_cancel reg_id \
    -datatype integer \
    -widget hidden \
    -value $reg_id

element create confirm_cancel inform_of_cancel \
    -label "Action" \
    -datatype text \
    -widget inform \
    -value "Cancel a reservation for $event_info(name), and send the registrant a message to notify him/her that their reservation was canceled"

if {[exists_and_not_null event_info(contact_email)]} {       
    set from_addr "$event_info(contact_email) (the default contact for this event)"
} else {
# do we want a parameter for this?
    set from_addr "[ad_outgoing_sender] (the system wide default outgoing sender)"
}        

element create confirm_cancel send_message_from \
    -label "From" \
    -datatype text \
    -widget inform \
    -value $from_addr

element create confirm_cancel send_message_to \
    -label "To" \
    -datatype text \
    -widget inform \
    -value $reg_info(user_email)

element create confirm_cancel message_subject \
    -label "Subject" \
    -datatype text \
    -widget inform \
    -value "Your registration for $event_info(name) has been canceled"


element create confirm_cancel email_body \
    -label "Email Message" \
    -datatype text \
    -widget textarea \
    -html {cols 70 rows 8 wrap soft} \
    -value "$reg_info(user_name),

Your registration request for $event_info(name) - $event_info(timespan) has been canceled.

Sincerely,

Event Administrator"

if {[template::form is_valid confirm_cancel]} {
    template::form get_values confirm_cancel reg_id email_body return_url

    events::registration::cancel -reg_id $reg_id -email_body $email_body

    if {![exists_and_not_null return_url]} {
        set return_url "reg-view?reg_id=$reg_id"
    }        


    ad_returnredirect $return_url
    ad_script_abort

}

ad_return_template

