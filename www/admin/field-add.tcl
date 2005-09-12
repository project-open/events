# File:  events/www/admin/field-add.tcl

ad_page_contract {
    Allows admins to select from existing custom fields

    @param activity_id the field's activity
    @param event_id the field's event

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activity-field-remove.tcl,v 3.6.6.4 2000/09/22 01:37:35 kevin Exp
} {
    {event_id ""}
    {activity_id ""}
    {attribute_ids:multiple ""}
}

if {[exists_and_not_null event_id]} {
    set title "Add Custom Fields"
    set field_create "field-create?activity_id=$activity_id&event_id=$event_id"
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] \
	    [list "event?event_id=$event_id" "Event"] "Add Custom Fields"]
    set attributes [db_list_of_lists select_available_event_fields {}]
} else {
    set title "Add Default Custom Fields"
    set field_create "field-create?activity_id=$activity_id"
    set context_bar [ad_context_bar [list "activities" "Activities"] \
	    [list "activity?activity_id=$activity_id" "Activity"] "Add Default Custom Fields"]
    set attributes [db_list_of_lists select_available_activity_fields {}]
}

if {[exists_and_not_null attributes]} {
    set attributes_p t
} else {
    set attributes_p f
}

form create field_add

element create field_add activity_id \
	-optional \
	-widget hidden \
	-datatype integer

element create field_add event_id \
	-optional \
	-widget hidden \
	-datatype integer

element create field_add attribute_ids \
	-label "Available Fields" \
	-widget multiselect \
	-datatype integer \
	-help_text "Select multiple fields by holding down the Control key" \
	-options $attributes

element create field_add submit \
	-label "Add fields" \
	-datatype text \
	-widget submit

if {[template::form is_valid field_add]} {
     
    if {[exists_and_not_null event_id]} {
        foreach attribute_id $attribute_ids {
	    events::registration::map_attribute -event_id $event_id -attribute_id $attribute_id
	}
	set redirect_url "event?event_id=$event_id"
    } else {
	foreach attribute_id $attribute_ids {
	    events::registration::map_attribute -activity_id $activity_id -attribute_id $attribute_id
	}
	set redirect_url "activity?activity_id=$activity_id"
    }

    ad_returnredirect $redirect_url
    ad_script_abort

}

if {[exists_and_not_null event_id]} {
    element set_properties field_add activity_id -value $activity_id
    element set_properties field_add event_id -value $event_id
} else {
    element set_properties field_add activity_id -value $activity_id
}

ad_return_template
