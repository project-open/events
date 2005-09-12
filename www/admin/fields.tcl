# events/www/admin/roles.tcl
ad_page_contract {
    Displays a list of roles
    Details for specific roles are one click deep.

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activities.tcl,v 3.8.2.6 2000/09/22 01:37:34 kevin Exp

} {
} -properties {
    custom_fields:multirow
}

set context_bar [ad_context_bar "Custom Fields"]

db_multirow custom_fields select_custom_fields {}

ad_return_template
