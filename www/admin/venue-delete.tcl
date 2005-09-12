# events/www/admin/venue-delete.tcl

ad_page_contract {
    deletes a venue

    @param venue_id the venue to be deleted

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {venue_id:integer,notnull}
} -validate {
    exists_p -requires {venue_id} { 
	if { ![events::venue::exists_p -venue_id $venue_id] } {
	    ad_complain "We couldn't find the venue you specified."
	    return 0
	}
	return 1
    }
    in_use_p -requires {venue_id} {
	if { [events::venue::in_use_p -venue_id $venue_id] } {
	    ad_complain "This venue is being
	    used by one or more events.  You cannot delete this
	    venue unless no events are located there."
	    return 0
	}
	return 1
    }
}

events::venue::delete -venue_id $venue_id

ad_returnredirect "venues"

