# events/www/admin/order-history-person.tcl

ad_page_contract {

    displays the order history of a person

    @param user_id
    @author Matthew Geddert (geddert@yahoo.com)

} {
    {user_id:integer,notnull}
} -properties {
     reg_history:multirow
} -validate {
    user_name_select -requires {user_id} { 
	if { ![db_0or1row select_user_info {}] } {
	    ad_complain "We couldn't find the user you asked for."
	    return 0
	}
	return 1
    }
}

db_1row select_user_info {}
set user_email [ad_convert_to_html $user_email]


set ad_url [ad_url]

set member_link [acs_community_member_link -user_id $user_id -label "${ad_url}[acs_community_member_url -user_id $user_id]"]


# get the variables needed by the sql query
set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]
set package_id [ad_conn package_id]

db_multirow reg_history select_reg_history {}  

set title "$user_name's Order History"
set context [list $title]

ad_return_template

