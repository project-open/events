# events/www/admin/venues-ae.tcl

ad_page_contract {
    Add or edit a venue.
    
    @param venue_id the venue if we're editing a venue
    @param return_url the return url if we're adding a venue

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    venue_id:integer,optional
    {return_url:optional}
} -properties {
    title:onevalue
    context:onevalue
    in_use_p:onevalue
}

set tz_list [db_list_of_lists get_timezones "select tz, tz_id from timezones order by tz"]
set tz_list [linsert $tz_list 0 ""]

set iso_list [db_list_of_lists get_isos "select default_name, iso from countries order by default_name"]

ad_form -name venues_ae -export {return_url} -form {

venue_id:key

{venue_name:text(text)
    {label "Venue Name"}
    {html {size 20}}}

{address1:text(text),optional
    {label "Address 1"}
    {html {size 50}}}

{address2:text(text),optional
    {label "Address 2"}
    {html {size 50}}}

{city:text(text),optional
    {label "City"}
    {html {size 50}}}

{usps_abbrev:text(text),optional
    {label "State"}
    {html {size 2}}}

{postal_code:text(text),optional
    {label "Postal Code"}
    {html {size 20}}}

{time_zone:text(select),optional
    {label "Time Zone"}
    {options $tz_list}}

{iso:text(select)
    {label "Country"}
    {options $iso_list}}

{phone_number:text(text),optional
    {label "Phone Number"}
    {html {size 30}}}

{fax_number:text(text),optional
    {label "Fax Number"}
    {html {size 30}}}

{email:text(text),optional
    {label "Email"}
    {html {size 30}}}

{max_people:integer(text),optional
    {label "Maximum Capacity"}
    {html {size 20}}}

{needs_reserve_p:text(select)
    {label "Needs Reservation"}
    {options {{No f} {Yes t}}}}

{description:text(textarea),optional
    {label "Description"}
    {html {cols 70 rows 8 wrap soft}}
    {help_text "Include directions"}}

} -select_query_name select_venue -validate {

} -new_data {
    set package_id [ad_conn package_id]
    set venue_id [events::venue::new -venue_id $venue_id \
	    -package_id $package_id \
	    -venue_name $venue_name \
	    -address1 $address1 \
	    -address2 $address2 \
	    -city $city \
	    -usps_abbrev $usps_abbrev \
	    -postal_code $postal_code \
	    -time_zone $time_zone \
	    -iso $iso \
	    -phone_number $phone_number \
	    -fax_number $fax_number \
	    -email $email \
	    -needs_reserve_p $needs_reserve_p \
	    -max_people $max_people \
	    -description $description ]

} -edit_data {

    events::venue::edit -venue_id $venue_id \
	    -venue_name $venue_name \
	    -address1 $address1 \
	    -address2 $address2 \
	    -city $city \
	    -usps_abbrev $usps_abbrev \
	    -postal_code $postal_code \
	    -time_zone $time_zone \
            -iso $iso \
	    -phone_number $phone_number \
	    -fax_number $fax_number \
	    -email $email \
	    -needs_reserve_p $needs_reserve_p \
	    -max_people $max_people \
	    -description $description

} -after_submit {

    if {[exists_and_not_null return_url]} {
	ad_returnredirect "$return_url&venue_id=$venue_id"
    } else {
	ad_returnredirect "venues"
    }
    ad_script_abort
}

if { ![ad_form_new_p -key venue_id] } {
    set title "Update a Venue"
    set context [ad_context_bar [list "venues" "Venues"] " Edit Venue"]
    set in_use_p [events::venue::in_use_p -venue_id $venue_id]
} else {
    set title "Add a New Venue"
    set context [ad_context_bar [list "venues" "Venues"] " New Venue"]
    set in_use_p 1
    element set_value venues_ae iso "US"
}

ad_return_template


