# events/www/admin/event-toggle-available-p.tcl

ad_page_contract {
    Toggles the availability of an event.

    @param event_id the event whose availability we're toggling

    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
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

db_transaction {

    events::event::toggle_available_p -event_id $event_id
    
    events::event::get -event_id $event_id -array event_info

    if { [db_0or1row select_ecommerce_info {}] } {
	set user_id [ad_get_user_id]
	set peeraddr [ns_conn peeraddr]
	
	db_dml toggle_active_p_update {}
    }

}

ad_returnredirect "event?event_id=$event_id"