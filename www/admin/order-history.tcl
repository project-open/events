# /events/www/admin/order-history.tcl
ad_page_contract {

    Present a selection of views for order history.

    @author Matthew Geddert (geddert@yahoo.com)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id order-history.tcl,v 3.4.6.3 2000/09/22 01:37:38 kevin Exp


} {
} -properties {
    context_bar:onevalue
}
ad_require_permission [ad_conn package_id] admin
set context [list "Order History"]

ad_return_template
