# /events/www/index.tcl

ad_page_contract {

    Displays all upcoming events and the breakdown of registrations
    for them.  Offers various admin options, such as looking at
    registration stats or available venues/activities.  New event
    creation, and checking out/editing events not currently available to
    the public, must be done through subsidiary pages.  
    @param orderby for ad_table

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs-id $Id index.tcl,v 3.19.2.5 2000/09/22 01:37:37 kevin Exp $
} {
} -properties {
    select_event_info:multirow
    context_bar:onevalue
    admin_p:onevalue
    package_id:onevalue
}

set title "Events"
set context [list $title]
set user_id [ad_verify_and_get_user_id]
set package_id [ad_conn package_id]
set admin_p [ad_permission_p $package_id admin]

set system_name [ad_system_name]

set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set date_format "Month DD, YYYY"
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

db_multirow -extend { view_url } events select_event_info {} {
    set view_url "event-info?[export_vars { event_id }]"
    set description [ad_convert_to_html -html_p $html_p -- $description]
}

ad_return_template
