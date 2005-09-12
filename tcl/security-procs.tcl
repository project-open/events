ad_library {

    Events Security Library
    
    each security type has two associated procs, the can_*****_p returns a zero or one if the 
    party requesting permission has permission in that area. The require_***** proc redirects
    the user to the not-allowed page.

    @creation-date 2002-11-04
    @author Matthew Geddert (geddert@yahoo.com)
    @cvs-id $Id: 

}

namespace eval events::security {

    ad_proc -private do_abort {} {
        do an abort if security violation
    } {
        if { [ad_conn user_id] == 0 } { 
            ad_redirect_for_registration
        } else {
#
# if you want it 
# implement logging here
#
            ad_returnredirect "not-allowed"
        }
        ad_script_abort
    }    

# events permissions

    ad_proc -public can_read_event_p {
        {-user_id ""}
        {-event_id:required}
    } {
        return [permission::permission_p -party_id $user_id -object_id $event_id -privilege read]
    }

    ad_proc -public require_read_event {
        {-user_id ""}
        {-event_id:required}
    } {
        if {![can_read_event_p -user_id $user_id -event_id $event_id]} {
            do_abort
        }
    }
 
    ad_proc -public can_admin_event_p {
        {-user_id ""}
        {-event_id:required}
    } {
        return [permission::permission_p -party_id $user_id -object_id $event_id -privilege admin]
    }

    ad_proc -public require_admin_event {
        {-user_id ""}
        {-event_id:required}
    } {
        if {![can_admin_event_p -user_id $user_id -event_id $event_id]} {
            do_abort
        }
    }
 
    ad_proc -public can_register_for_event_p {
        {-user_id ""}
        {-event_id:required}
    } {
        return [permission::permission_p -party_id $user_id -object_id $event_id -privilege write]
    }

    ad_proc -public require_register_for_event {
        {-user_id ""}
        {-event_id:required}
    } {
        if {![can_register_for_event_p -user_id $user_id -event_id $event_id]} {
            do_abort
        }
    }
 
# activity permissions

    ad_proc -public can_read_activity_p {
        {-user_id ""}
        {-activity_id:required}
    } {
        return [permission::permission_p -party_id $user_id -object_id $activity_id -privilege read]
    }

    ad_proc -public require_read_activity {
        {-user_id ""}
        {-activity_id:required}
    } {
        if {![can_read_activity_p -user_id $user_id -activity_id $activity_id]} {
            do_abort
        }
    }

    ad_proc -public can_admin_activity_p {
        {-user_id ""}
        {-activity_id:required}
    } {
        return [permission::permission_p -party_id $user_id -object_id $activity_id -privilege admin]
    }

    ad_proc -public require_admin_activity {
        {-user_id ""}
        {-activity_id:required}
    } {
        if {![can_admin_activity_p -user_id $user_id -activity_id $activity_id]} {
            do_abort
        }
    }
 
# End of namespace
}
