# events/www/admin/order-history-one.tcl

ad_page_contract {

    displays the order history of an event

    @param event_id
    @author Matthew Geddert (geddert@yahoo.com)

} {
    {specific_reg_type ""}
    {activity_id:integer}
} -properties {
     activity_members:multirow
} -validate {
    activity_exists_p -requires {activity_id} { 
	if { ![events::activity::exists_p -activity_id $activity_id] } {
	    ad_complain "We couldn't find the activity you asked for."
	    return 0
	}
	return 1
    }
}

# what reg state do we plug into the database?
set date_format [parameter::get -parameter date_format -default "MM/DD/YYYY"]
set time_format [parameter::get -parameter time_format -default "HH12:MIam"]

if {[string equal $specific_reg_type "canceled"] ||  
    [string equal $specific_reg_type "approved"] ||  
    [string equal $specific_reg_type "waiting"] ||  
    [string equal $specific_reg_type "pending"]} {
db_multirow activity_members select_specific_reg_type {}  
} else {
db_multirow activity_members select_activity_members {}      
}

events::activity::get -activity_id $activity_id -array activity_info
events::activity::get_stats -activity_id $activity_id -array activity_stats
set title "Order History for $activity_info(name)"
set context [list [list "activities" Activities] [list "activity?activity_id=$activity_id" $activity_info(name)] "Orders"]

ad_return_template
