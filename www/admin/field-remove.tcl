# File:  events/www/admin/activity-field-delete.tcl

ad_page_contract {
    Allows admins to confirm the removal of a field 
    associated with the selected activity/event

    @param activity_id the field's activity
    @param event_id the field's event
    @param attribute_name the name of the field's table column
    @param attribute_id the name of the field's table column

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id activity-field-remove.tcl,v 3.6.6.4 2000/09/22 01:37:35 kevin Exp
} {
    {event_id ""}
    {activity_id ""}
    {attribute_id:integer,notnull}
    {attribute_name ""}
}

if {[exists_and_not_null event_id]} {
    events::event::get -event_id $event_id -array info
    set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] [list "event?event_id=$event_id" Event] "Remove Custom Field"]
} else {
    events::activity::get -activity_id $activity_id -array info
    set context_bar [ad_context_bar [list "activities" Activities] [list "activity?activity_id=$activity_id" Activity] "Remove Custom Field"]
}

set title "Remove Custom Field?"

set prompt "Remove field from $info(name)?"

form create field_remove

element create field_remove activity_id \
    -datatype integer \
    -optional \
    -widget hidden

element create field_remove event_id \
    -datatype integer \
    -optional \
    -widget hidden

element create field_remove attribute_name \
    -label "Field Name" \
    -datatype integer \
    -widget inform \
    -optional \
    -value $attribute_name

element create field_remove attribute_id \
    -datatype integer \
    -widget hidden \
    -value $attribute_id

element create field_remove submit \
    -label "Remove custom field" \
    -datatype text \
    -widget submit

if {[template::form is_valid field_remove]} {
    template::form get_values field_remove attribute_id

    if {[exists_and_not_null event_id]} {
	set redirect_url "event?event_id=$event_id"
	events::registration::unmap_attribute -attribute_id $attribute_id \
		-event_id $event_id
    } else {
	set redirect_url "activity?activity_id=$activity_id"
	events::registration::unmap_attribute -attribute_id $attribute_id \
		-activity_id $activity_id
    }

    ad_returnredirect $redirect_url
    ad_script_abort
}

if {[exists_and_not_null event_id]} {
    element set_properties field_remove activity_id -value $activity_id
    element set_properties field_remove event_id -value $event_id
} else {
    element set_properties field_remove activity_id -value $activity_id
}

ad_return_template
