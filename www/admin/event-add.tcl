# events/www/admin/event-add.tcl

ad_page_contract {
    Purpose: Allow an admin to select a venue for a new event, or
    add a new venue if necessary first.

    @param activity_id the activity to which we're adding an event

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {activity_id:integer,notnull}
}

set venues [events::venue::venues_get_options]

if {[llength $venues] == 0} {
    set no_venues 1
} else {
    set no_venues 0
}

form create venue_select -action event-add-2

element create venue_select activity_id \
    -label "Activity ID" \
    -datatype text \
    -widget hidden \
    -value $activity_id

element create venue_select venue_id \
    -label "Select a venue for your new event" \
    -datatype text \
    -widget select \
    -options $venues

events::activity::get -activity_id $activity_id -array activity_info
set context [list [list "activities" Activities] [list "activity?[export_vars { activity_id }]" $activity_info(name)] "Add Event"]
set activity_name $activity_info(name)
set title "Add a New Event for $activity_name"
set return_url "event-add-2?activity_id=$activity_id"
