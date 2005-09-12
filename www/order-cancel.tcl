# events/www/order-cancel.tcl
ad_page_contract {

    Purpose: Give users the option of cancelling a registration.

    @param  reg_id the registration to cancel

    @author Matthew Geddert (geddert@yahoo.com)
    @author Bryan Che (bryanche@arsdigita.com)
    @creation date 2002-11-11

} {
    {reg_id:naturalnum,notnull}
} -validate {
    registration_exists_p -requires {reg_id} { 
	if { ![events::registration::exists_p -reg_id $reg_id] } {
	    ad_complain "We could not find the registration you asked for."
	    return 0
	}
	return 1
    }
}

set user_id [ad_verify_and_get_user_id]
ad_maybe_redirect_for_registration

if { ![db_0or1row reg_exists {}] } {
    ad_return_warning "Could Not Find Registration" "We could not find the
                       registration you asked for, or the registration you
                       ask for does not belong to you."
}

events::registration::get -reg_id $reg_id -array reg_info
events::event::get -event_id $reg_info(event_id) -array event_info
events::venue::get -venue_id $event_info(venue_id) -array venue_info

if {[string compare $event_info(reg_cancellable_p) "f"] == 0} {
    if {[string compare $reg_info(reg_state) "approved"] == 0} {
    ad_return_warning "This Registration Cannot Be Canceled" "Since this registration has been
                       approved, you may not cancel it through this website."

    }
}

set title "Cancel Your Registration for $event_info(name)"
set context [list [list "event-info?event_id=$reg_info(event_id)" "$event_info(name) in $venue_info(city)"] "Cancel Your Registration"]


form create confirm_cancel

element create confirm_cancel reg_id \
    -datatype integer \
    -widget hidden \
    -value $reg_id

element create confirm_cancel user_name \
    -label "Your Name" \
    -datatype text \
    -widget inform \
    -value "<table width=100% cellpadding=0 cellspacing=0><tr><td align=left>$reg_info(user_name)</td><td align=right> (Not you? <a href=\"/register/logout\">Login as somebody else</a>) </td></tr></table> "

element create confirm_cancel inform_of_cancel \
    -label "Action" \
    -datatype text \
    -widget inform \
    -value "Cancel my reservation for $event_info(name)"

element create confirm_cancel inform_of_action \
    -label "Warning" \
    -datatype text \
    -widget inform \
    -value "<font color=red>This action is irreversible. You may choose to re-register for this event at a later time, but you will be placed at the end of the waiting list.</font>"

element create confirm_cancel confirm_p \
    -label "Are you sure you want to cancel?" \
    -datatype text \
    -widget radio \
    -options {{Yes t} {No f}} \
    -value f

if {[template::form is_valid confirm_cancel]} {
    template::form get_values confirm_cancel reg_id confirm_p


        if {[string compare $confirm_p "t"] == 0} {

            set email_body "$reg_info(user_name),\n\n"
            append email_body "As per your request, your registration for $event_info(name) has been canceled.\n\n"
            append email_body "If you change your mind, you may place a new registration for this event here:\n"
            append email_body "$reg_info(package_url)order-one?event_id=$reg_info(event_id)"

            events::registration::cancel -reg_id $reg_id -email_body $email_body
            events::email::admin_canceled -reg_id $reg_id

        }

ad_returnredirect "order-check?reg_id=$reg_id"
ad_script_abort

}

ad_return_template

