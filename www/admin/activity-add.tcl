#/packages/events/www/admin/activity-ae.tcl

ad_page_contract {
    If an activity_id is supplied, the page will display
    the activity to an admin with options
    for modifying the event. Otherwise, a blank form for
    the creation of a new event will be provided.
    
    @param activity_id the activity at which we're looking
    @param email_from_search 
    @param user_id_from_search 
    @param no_contact
    @param default_contact_user_id

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {activity_id:naturalnum,optional}
    {email_from_search:optional}
    {user_id_from_search:optional}
    {no_contact_flag:optional}
    {default_contact_user_id:naturalnum,optional}
}

set context [list [list activities Activities] "New Activity"]

form create activity

element create activity name \
    -label "Activity Name" \
    -datatype text \
    -widget text \
    -html {size 60}

element create activity default_contact_user_id \
    -label "Default Contact Person" \
    -datatype search \
    -widget search \
    -result_datatype integer \
    -options [events::organizer::users_get_options] \
    -optional \
    -value "" \
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
    -help_text "Note: If you don't put http:// in your url, the link will be relative" \
    -optional

element create activity description \
    -label Description \
    -datatype text \
    -widget textarea \
    -html {cols 60 rows 10 wrap soft} \
    -optional

if {[template::form is_valid activity]} {
    template::form get_values activity \
        name description detail_url default_contact_user_id

    set package_id [ad_conn package_id]
    set activity_id [events::activity::new \
        -name $name \
	-description $description \
	-detail_url $detail_url \
        -default_contact_user_id $default_contact_user_id \
        -package_id $package_id
    ]

    ad_returnredirect "activity?activity_id=$activity_id"
    ad_script_abort
}

ad_return_template
