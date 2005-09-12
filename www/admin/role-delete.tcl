# File:  events/www/admin/role-delete.tcl

ad_page_contract {
    Allows admins to confirm the removal of a role

    @param role_id the id of the role

    @author Michael Steigman (michael@steigman.net)
    @author Bryan Che (bryanche@arsdigita.com)
    @cvs_id $Id$
} {
    {role_id:naturalnum,notnull}
}

events::organizer::get_role -role_id $role_id -array role_info

set title "Delete Role?"

set context_bar [ad_context_bar [list "roles" Roles] [list "role?role_id=$role_id" Role] "Delete Role"]

set question "Delete role from system?"

form create role_delete

element create role_delete role \
    -label "Role name" \
    -datatype text \
    -widget inform \
    -value $role_info(role)

element create role_delete role_id \
    -label "Role" \
    -datatype integer \
    -widget hidden \
    -value $role_id

element create role_delete submit \
    -label "Delete role" \
    -datatype text \
    -widget submit

if {[template::form is_valid role_delete]} {
    events::organizer::delete_role \
		-role_id $role_id

    ad_returnredirect roles
    ad_script_abort
}

ad_return_template
