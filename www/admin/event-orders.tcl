# events/www/admin/order-history-one.tcl

ad_page_contract {

    displays the order history of an event

    @param event_id
    @author Matthew Geddert (geddert@yahoo.com)

} {
    {specific_reg_type ""}
    {event_id:integer}
} -properties {
     event_members:multirow
} -validate {
    event_exists_p -requires {event_id} { 
	if { ![events::event::exists_p -event_id $event_id] } {
	    ad_complain "We couldn't find the event you asked for."
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
db_multirow event_members select_specific_reg_type {}  
} else {
db_multirow event_members select_event_members {}      
}

events::event::get_stats -event_id $event_id -array event_stats
events::event::get -event_id $event_id -array event_info
set title "Order History for $event_info(name)"
set context [list [list "activities" Activities] [list "activity?activity_id=$event_info(activity_id)" $event_info(name)] [list "event?event_id=$event_id" "$event_info(city)"] "Orders"]
set count_spotsremaining [expr $event_stats(max_people) - $event_stats(approved)]

if { ![empty_string_p $event_stats(max_people)] && $count_spotsremaining == 0 } {
     set max_approved t
} else {
     set max_approved f
}

ad_return_template
