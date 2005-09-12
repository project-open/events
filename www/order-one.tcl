# events/www/order-one.tcl  

ad_page_contract {
    Registration form for an event.

    @param event_id the event for which the user is signing up

    @author Matthew Geddert (geddert@yahoo.com)
    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id order-one.tcl,v 3.19.2.5 2000/09/22 01:37:33 kevin Exp $
} {
    {event_id:integer,notnull}
} -validate {
    event_exists_p -requires {event_id} { 
	if { ![events::event::exists_p -event_id $event_id] } {
	    ad_complain "We couldn't find the event you asked for."
	    return 0
	}
	return 1
    }
}
ad_maybe_redirect_for_registration
set user_id [ad_verify_and_get_user_id]

if { [events::event::reg_deadline_elapsed_p -event_id $event_id] } {    
    ad_return_warning "Registration Deadline Elapsed" "The registration 
                       deadline for this event has passed."
}        


# check to see if this person has already registered
if {[db_0or1row get_reg_id {}]} {       
    ad_return_warning "Already Registered" "You have already registered for this Event. You are not permitted
                       to register more than once."
}        




events::security::require_read_event -event_id $event_id
events::event::get -event_id $event_id -array event_info
events::event::get_stats -event_id $event_id -array event_stats

set context [list [list "event-info?event_id=$event_id" "$event_info(name) in $event_info(city)"] Register]

multirow create reg_notes note


if { [string equal $event_info(reg_needs_approval_p) "t"] } {
    multirow append reg_notes {
        We will notify you when your registration has been approved.
    }
    if { ![empty_string_p $event_stats(max_people)] && 0 >= [expr $event_stats(max_people) - $event_stats(approved)] } {
        multirow append reg_notes {
            The maximum number of registrations have already been approved
            and registered. If an administrator approves of your request, you
            will likely be placed on the waiting list.
        }
    }
    if { [string equal $event_info(reg_cancellable_p) "f"] } {
        multirow append reg_notes {
            Registrations for this event cannot be canceled. Once approved,
            you are committed to coming.
        }
    }
} else {
    if { ![empty_string_p $event_stats(max_people)] && 0 >= [expr $event_stats(max_people) - $event_stats(approved)] } {
        multirow append reg_notes {
            This event has already received its maximum number of
            registrations.  If you register for this event, you will be
            placed on a waiting list.
        }
    } else {
        if { $event_stats(waiting) > 0 } {
            multirow append reg_notes {
                Although this event is not filled to maximum 
                capacity, there is a waiting list. If you register for this event an administrator
                will need to approve of your registration.
            }
        }
    }
    if { [string equal $event_info(reg_cancellable_p) "f"] } {
        multirow append reg_notes {
            Registrations for this event cannot be canceled. Once registered,
            you are committed to coming.
        }
    }
}

set user_name [db_exec_plsql select_user_name {}]


form create registration -edit_buttons { { "Register" ok } }

element create registration event_id \
    -datatype integer \
    -widget hidden \
    -value $event_id

element create registration user_id \
    -datatype integer \
    -widget hidden \
    -value $user_id

element create registration user_name \
    -label "Your Name" \
    -datatype text \
    -widget inform \
    -value "<table width=100% cellpadding=0 cellspacing=0><tr><td align=left>$user_name</td><td align=right> \(Not you? <a href=\"/register/logout\">Login as somebody else</a>)</td></tr></table> "

element create registration comments \
    -label "Optional comment" \
    -datatype text \
    -widget textarea \
    -html {cols 40 rows 8 wrap soft} \
    -optional

if {[template::form is_valid registration]} {
    template::form get_values registration event_id user_id comments

    set reg_id [events::registration::new -event_id $event_id -user_id $user_id -comments $comments]

    ad_returnredirect "order-check?reg_id=$reg_id"
    ad_script_abort
}

ad_return_template

# CUSTOM FIELDS WILL BE DEALT WITH VIA A SERVICE CONTRACT WITH SURVEY
#
#db_foreach select_custom_fields {} {
#    set element "
#    {$name:[attribute::translate_datatype $datatype](text)
#    {label $pretty_name}}"
#    ad_form -extend -name registration -form $element
#}
