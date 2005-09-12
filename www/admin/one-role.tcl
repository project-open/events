# events/www/admin/roles.tcl

ad_page_contract {
    Displays a list of roles
    Details for specific roles are one click deep.

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$

} {
    {role_id:naturalnum,notnull}
}

set title "One Role"

set context_bar [ad_context_bar [list "roles" "Roles"] "One Role"]

events::organizer::get_role -role_id $role_id -array role_info

db_multirow arm select_activity_role_mappings {}

db_multirow erm select_event_role_mappings {}

ad_return_template
