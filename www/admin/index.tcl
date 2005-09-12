# /events/www/admin/index.tcl

ad_page_contract {

    Displays all upcoming events and the breakdown of registrations
    for them.  Offers various admin options, such as looking at
    registration stats or available venues/activities.  New event
    creation, and checking out/editing events not currently available to
    the public, must be done through subsidiary pages.  
    @param orderby for ad_table

    This is the index page for events administration.

    @author Matthew Geddert (geddert@yahoo.com)
    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs-id $Id index.tcl,v 3.19.2.5 2000/09/22 01:37:37 kevin Exp $
} {
} -properties {
    available_events_and_locations:multirow
    context_bar:onevalue
}


ad_require_permission [ad_conn package_id] admin
set package_id [ad_conn package_id]
set context_bar [ad_context_bar]

set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

db_multirow available_events_and_locations select_available_events_and_locations {}

set parameters_edit_url "/admin/site-map/parameter-set?[export_vars { { package_id {[ad_conn package_id]} } }]"

