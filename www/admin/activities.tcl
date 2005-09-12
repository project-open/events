# events/www/admin/activities.tcl
ad_page_contract {
    Displays a list of current and discontinued activities.
    Details for specific activities are one click deep.

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$

} {
} 

set package_id [ad_conn package_id]

set context [list Activities]

db_multirow available_activities select_available_activities {}

db_multirow unavailable_activities select_unavailable_activities {}

ad_return_template
