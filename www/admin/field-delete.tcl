# File:  events/www/admin/field-delete.tcl

ad_page_contract {
    Allows admins to confirm the removal of a field

    @param role_id the id of the role

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activity-field-remove.tcl,v 3.6.6.4 2000/09/22 01:37:35 kevin Exp
} {
    {attribute_id:naturalnum,notnull}
}

events::registration::get_attribute -attribute_id $attribute_id -array attribute_info

set title "Delete Field?"

set context_bar [ad_context_bar [list "fields" "Custom Fields"] [list "field?attribute_id=$attribute_id" "Custom Field"] "Delete Custom Field"]

set prompt "Delete custom field from system?"

form create field_delete

element create field_delete field \
    -label "Custom Field" \
    -datatype text \
    -widget inform \
    -value $attribute_info(name)

element create field_delete attribute_id \
    -datatype integer \
    -widget hidden \
    -value $attribute_id

element create field_delete submit \
    -label "Delete field" \
    -datatype text \
    -widget submit

if {[template::form is_valid field_delete]} {
    events::registration::delete_attribute \
	    -attribute_id $attribute_id \
	    -attribute_name $attribute_info(name)

    ad_returnredirect fields
    ad_script_abort
}

ad_return_template
