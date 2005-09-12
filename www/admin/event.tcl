# events/www/admin/event.tcl

ad_page_contract {
    Purpose:  List one event with details, for administration.
    (that is, with links for altering and updating the event info)

    @param event_id the event at which we're looking

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {event_id:integer,notnull}
} -properties {
    custom_fields:multirow
    org_roles:multirow
    event_organizers:onevalue
} -validate {
    event_exists_p -requires {event_id} { 
	if { ![events::event::exists_p -event_id $event_id] } {
	    ad_complain "We couldn't find the event you asked for."
	    return 0
	}
	return 1
    }
}

events::event::get -event_id $event_id -array event_info
events::event::get_stats -event_id $event_id -array event_stats

set count_spotsremaining [expr $event_stats(max_people) - $event_stats(approved)]

set pretty_location ""
if { [empty_string_p $event_info(city)] } {
    append pretty_location "$event_info(name)"
} else {
    append pretty_location "$event_info(city)"
}
if { ![empty_string_p $event_info(usps_abbrev)] } {
    if { ![empty_string_p $event_info(city)] } {
	append pretty_location ", "
    } else {
	append pretty_location " - "
    }
    append pretty_location "$event_info(usps_abbrev)"
}
set title "$pretty_location: $event_info(timespan)"
set context [list [list "activities" Activities] [list "activity?activity_id=$event_info(activity_id)" $event_info(name)] $pretty_location]

set attachments_enabled_p [events::event::attachments_enabled_p]
if {$attachments_enabled_p} {
    set attachments [attachments::get_attachments -base_url "../" -object_id $event_id]
    set attachment_link "../attach/attach?object_id=$event_id&return_url=../admin/event?event_id=$event_id&pretty_name=$event_info(name)"
}

set cancelled_p 0
if {[string compare $event_info(available_p) "f"] == 0 && $event_stats(total_interested) > 0} {
    set cancelled_p 1
}

#db_multirow custom_fields select_custom_fields {}
db_multirow org_roles select_org_roles {}
set event_organizers [db_string select_event_organizers_count {}]
#db_multirow eoe select_event_organizers_email {}

events::event::get_creator -event_id $event_id -array creator_info
set creator_name $creator_info(name)
set creator_email $creator_info(email)

ad_form -name event_notes -form {

    event_id:key(acs_object_id_seq)
    {refreshments_note:text(textarea),optional
	{label "Refreshments Note"}
	{html {cols 65 rows 16 wrap soft}}}
    {av_note:text(textarea),optional
	{label "Audio/Visual Note"}
	{html {cols 65 rows 16 wrap soft}}}
    {additional_note:richtext(richtext),optional
	{label "Additional Note"}
	{html {cols 65 rows 16 wrap soft}}}
}

element create event_notes submit \
    -label "Update" \
    -datatype text \
    -widget submit
	
if {[form is_submission event_notes]} {
    template::form get_values event_notes \
	    event_id refreshments_note av_note additional_note

    events::event::edit_event_notes \
	-event_id $event_id \
        -refreshments_note $refreshments_note \
	-av_note $av_note \
	-additional_note $additional_note

    ad_returnredirect "event?event_id=$event_id"
}

element set_properties event_notes event_id -value $event_id
element set_properties event_notes refreshments_note -value $event_info(refreshments_note)
element set_properties event_notes av_note -value $event_info(av_note)
element set_properties event_notes additional_note -value $event_info(additional_note)

ad_return_template
