# events/www/admin/organizer-add.tcl

ad_page_contract {
    Choose a user to add as an organizer for an event.

    @param event_id the event to which to add the organizer
    @param role_id the role for which we're adding an organizer, if it has already been created

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {event_id:integer,notnull}
    {activity_id:integer,notnull}
    {role_id:integer,optional}
}

events::event::get -event_id $event_id -array event_info

set name $event_info(name)

set title "Add a New Organizer"

set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] [list "event?event_id=$event_id" "Event"] "Add Organizer"]

form create organizer_add -action /acs-admin/users/search

element create organizer_add target \
    -datatype text \
    -widget hidden \
    -value "[ad_conn package_url]admin/organizer-add-2.tcl"

element create organizer_add custom_title \
    -datatype text \
    -widget hidden \
    -value "Choose a Member to Add as a Organizer for the $name event"

element create organizer_add passthrough \
    -datatype text \
    -widget hidden \
    -value "event_id role_id"

element create organizer_add event_id \
    -datatype text \
    -widget hidden \
    -value $event_id

element create organizer_add role_id \
    -datatype text \
    -widget hidden \
    -value $role_id

element create organizer_add email \
    -label "by Email address" \
    -datatype text \
    -widget text \
    -html {size 40}

element create organizer_add last_name \
    -label "or by Last name" \
    -datatype text \
    -widget text \
    -html {size 40}

element create organizer_add submit \
    -widget submit \
    -label "Search for an organizer"

ad_return_template

