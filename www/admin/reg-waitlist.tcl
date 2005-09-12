# events/www/admin/reg-approve.tcl
ad_page_contract {

    Approve a Registration.

    @param  reg_id the registration to cancel

    @author Matthew Geddert (geddert@yahoo.com)
    @creation date 2002-11-11

} {
    {reg_id:naturalnum,notnull}
    {return_url ""}
} -validate {
    registration_exists_p -requires {reg_id} { 
	if { ![events::registration::exists_p -reg_id $reg_id] } {
	    ad_complain "We could not find the registration you asked for."
	    return 0
	}
	return 1
    }
}

events::registration::waiting -reg_id $reg_id

if {![exists_and_not_null return_url]} {
   set return_url "reg-view?reg_id=$reg_id"
}        


ad_returnredirect $return_url
ad_script_abort


