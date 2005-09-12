# events/www/admin/field-add.tcl

ad_page_contract {
    Purpose: allows admins to add a custom field to the registrations
    forms for the specified event.

    @param event_id the activity to which we are adding a field
    @param after field after which this new field will appear

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activity-field-add.tcl,v 3.6.6.4 2000/09/22 01:37:35 kevin Exp
} {
    {event_id:integer,optional}
    {activity_id:integer,optional}
    {after:optional}
}

set datatypes [db_list_of_lists select_attribute_datatypes {}]

set categories [db_list_of_lists select_categories {}]

if {[exists_and_not_null event_id]} {
    set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] [list "event?event_id=$event_id" Event] "Custom Field"]
    set title "Add a New Custom Field"
} elseif {[exists_and_not_null activity_id]} {
    set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] "Custom Field"]
    set title "Add a New Default Custom Field"
} else {
    set context_bar [ad_context_bar [list "fields" "Custom Fields"] "Custom Field"]
    set title "Add a New Custom Field"
}

form create custom_field

element create custom_field activity_id \
    -datatype integer \
    -widget hidden \
    -optional

element create custom_field event_id \
    -datatype integer \
    -widget hidden \
    -optional

#element create custom_field after \
#    -label "After" \
#    -datatype integer \
#   -widget hidden

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

    set attribute_id [events::registration::new_attribute \
	    -attribute_name $attribute_name \
	    -pretty_name $pretty_name \
	    -pretty_plural $pretty_plural \
	    -category_id $category_id \
	    -datatype $datatype]

    if {[exists_and_not_null event_id]} {
	set redirect_url "event?event_id=$event_id"
	events::registration::map_attribute -event_id $event_id \
		-attribute_id $attribute_id
    } elseif {[exists_and_not_null activity_id]} {
	set redirect_url "event?activity_id=$activity_id"
	events::registration::map_attribute -activity_id $activity_id \
		-attribute_id $attribute_id
    } else {
	set redirect_url "fields?field_id=$activity_id"
    }

    ad_returnredirect $redirect_url
    ad_script_abort
}

if {[exists_and_not_null event_id]} {
    element set_properties custom_field event_id -value $event_id
    element set_properties custom_field activity_id -value $activity_id
} elseif {[exists_and_not_null activity_id]} {
    element set_properties custom_field activity_id -value $activity_id
}

if {[exists_and_not_null after]} {
    element set_properties custom_field after -value $after 
}

ad_return_template
