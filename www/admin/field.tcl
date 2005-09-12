# events/www/admin/fields.tcl

ad_page_contract {
    Displays a list of fields
    Details for specific roles are one click deep.

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activities.tcl,v 3.8.2.6 2000/09/22 01:37:34 kevin Exp

} {
    {attribute_id:naturalnum,notnull}
}

set title "One Custom Field"

set context_bar [ad_context_bar [list "fields" "Custom Fields"] "One Custom Field"]

events::registration::get_attribute -attribute_id $attribute_id -array attribute_info

db_multirow aam select_activity_custom_field_mappings {}

db_multirow eam select_event_custom_field_mappings {}

ad_return_template
