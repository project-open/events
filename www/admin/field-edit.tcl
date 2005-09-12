# events/www/admin/field-edit.tcl

ad_page_contract {
    Allows admins to confirm the removal of a field 
    associated with the selected activity/event

    @param attribute_id the name of the field's table column

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activity-field-remove.tcl,v 3.6.6.4 2000/09/22 01:37:35 kevin Exp
} {
    {attribute_id:integer,notnull}
}

set datatypes [db_list_of_lists select_attribute_datatypes {}]

set categories [db_list_of_lists select_categories {}]

set context_bar [ad_context_bar [list "fields" "Custom Fields"] "Edit Custom Field"]

set title "Edit Custom Field"

form create custom_field

element create custom_field attribute_id \
    -datatype integer \
    -widget hidden \
    -value $attribute_id

element create custom_field attribute_name \
    -label "Field Name" \
    -datatype text \
    -widget text \
    -html {size 40} 

element create custom_field pretty_name \
    -label "Pretty Name" \
    -datatype text \
    -widget text \
    -html {size 40} 

element create custom_field pretty_plural \
    -label "Pretty Plural" \
    -datatype text \
    -widget text \
    -html {size 40} 

element create custom_field datatype \
    -label "Type of Data" \
    -datatype text \
    -widget select \
    -options $datatypes

element create custom_field category_id \
    -label "Category" \
    -datatype text \
    -widget select \
    -options $categories

if {[template::form is_valid custom_field]} {
    template::form get_values custom_field attribute_name \
	    pretty_name pretty_plural datatype category_id

    events::registration::edit_attribute \
	    -attribute_id $attribute_id \
	    -attribute_name $attribute_name \
	    -pretty_name $pretty_name \
	    -pretty_plural $pretty_plural \
	    -category_id $category_id \
	    -datatype $datatype
    
    set redirect_url "fields?attribute_id=$attribute_id"
    ad_returnredirect $redirect_url
    ad_script_abort
}

events::registration::get_attribute -attribute_id $attribute_id -array attribute_info

element set_properties custom_field attribute_name -value $attribute_info(name)
element set_properties custom_field pretty_name -value $attribute_info(pretty_name)
element set_properties custom_field pretty_plural -value $attribute_info(pretty_plural)
element set_properties custom_field datatype -value $attribute_info(datatype)
element set_properties custom_field category_id -value $attribute_info(category_id)

ad_return_template
