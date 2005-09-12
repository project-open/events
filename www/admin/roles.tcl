# events/www/admin/roles.tcl
ad_page_contract {
    Displays a list of roles
    Details for specific roles are one click deep.

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$

} {
} -properties {
    roles:multirow
}

set context_bar [ad_context_bar Roles]

db_multirow roles select_roles {}

ad_return_template
