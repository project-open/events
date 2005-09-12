# events/www/admin/activity-edit.tcl

ad_page_contract {
    Allows admins to edit an activity's properties.

    @param activity_id the activity to edit
    @param email_from_search optional default contact person's email
    @param user_id_from_search optional default contact person's user_id
    @param no_contact_flat optional flag stating there is not default contact
    @param default_contact_user_id optional default contact person's user_id

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs-id activity-edit.tcl,v 3.8.2.7 2000/09/29 14:49:46 bryanche Exp
} {
    {activity_id:naturalnum,notnull}
} -validate {
    activity_exists -requires {activity_id} { 
	if { ![db_0or1row activity_exists {}] } {
	    ad_complain "We couldn't find the activity you asked for."
	    return 0
	}
	return 1
    }
}

form create activity

element create activity activity_id \
    -label "Activity ID" \
    -datatype integer \
    -widget hidden

element create activity name \
    -label "Activity Name" \
    -datatype text \
    -widget text \
    -html {size 60}

element create activity creator \
    -label "Creator" \
    -datatype text \
    -widget inform

element create activity default_contact_user_id \
    -label "Default Contact Person" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::organizer::users_get_options] \
    -optional \
    -search_query {
           select distinct u.first_names || ' ' || u.last_name as name, u.user_id
             from cc_users u
            where upper(decode(u.first_names,' ', '')  || decode(u.last_name,' ', '') || u.email || ' ' || decode(u.screen_name, ' ', '')) like upper('%'||:value||'%')
            order by name
}

element create activity detail_url \
    -label "Details URL" \
    -datatype text \
    -widget text \
    -html {size 50} \
    -help_text "Leave out http:// for relative URLs" \
    -optional

element create activity description \
    -label Description \
    -datatype text \
    -widget textarea \
    -html {cols 60 rows 10 wrap soft} \
    -optional

element create activity available_p \
    -label "Current or Discontinued" \
    -datatype text \
    -widget radio \
    -options {{Current t} {Discontinued f}} \
    -help_text "Discontinuing an activity will not cancel an activity's existing events. It only prevents you from adding <i>new</i> events to the activity"

if {[template::form is_valid activity]} {
    template::form get_values activity \
        activity_id name detail_url description available_p default_contact_user_id

    events::activity::edit \
	-activity_id $activity_id \
        -name $name \
	-detail_url $detail_url \
	-description $description \
	-available_p $available_p \
	-default_contact_user_id $default_contact_user_id

    ad_returnredirect "activity?activity_id=$activity_id"
    ad_script_abort
}

events::activity::get -activity_id $activity_id -array activity_info
set title "Edit $activity_info(name)"

set context [list [list activities "Activities"] \
	[list "activity?activity_id=$activity_id" "$activity_info(name)"] "Edit"]

element set_properties activity activity_id -value $activity_id
element set_properties activity name -value $activity_info(name)
element set_properties activity default_contact_user_id -value $activity_info(default_contact_user_id)
element set_properties activity detail_url -value $activity_info(detail_url)
element set_properties activity description -value $activity_info(description)
element set_properties activity available_p -value $activity_info(available_p)

events::activity::get_creator -activity_id $activity_id -array creator_info
element set_properties activity creator -value $creator_info(name)
ad_return_template

