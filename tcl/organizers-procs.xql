<?xml version="1.0"?>
<queryset>

    <fullquery name="events::organizer::new_role.new_org_role">
        <querytext>
	insert into events_organizer_roles
	(role_id, role, responsibilities, public_role_p)
	values
	(:role_id, :role, :responsibilities, :public_role_p)
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::map_role.insert_into_events_org_role_event_map">
        <querytext>
	insert into events_org_role_event_map
	(role_id, event_id)
	values
	(:role_id, :event_id)
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::map_role.insert_into_events_org_role_activity_map">
        <querytext>
	insert into events_org_role_activity_map
	(role_id, activity_id)
	values
	(:role_id, :activity_id)
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::unmap_role.delete_from_events_org_role_event_map">
        <querytext>
	delete from events_org_role_event_map
	 where role_id = :role_id
	   and event_id = :event_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::unmap_role.delete_from_events_organizers_map">
        <querytext>
	delete from events_organizers_map
	 where role_id = :role_id
	   and event_id = :event_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::unmap_role.delete_from_events_org_role_activity_map">
        <querytext>
	delete from events_org_role_activity_map
	 where role_id = :role_id
	   and activity_id = :activity_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::edit_role.edit_org_role">
        <querytext>
	update events_organizer_roles
	   set role = :role,
	       responsibilities = :responsibilities,
	       public_role_p = :public_role_p
	 where role_id = :role_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::delete_role.delete_org_role">
        <querytext>
	delete from events_organizer_roles
	 where role_id = :role_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::add_organizer.insert_into_events_organizers_map">
        <querytext>
	insert into events_organizers_map
	(role_id, event_id, user_id)
	values
	(:role_id, :event_id, :party_id)
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::edit_organizer.update_events_organizers_map">
        <querytext>
	update events_organizers_map
	   set user_id = :party_id
	 where role_id = :role_id
	   and event_id = :event_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::delete_organizer.delete_from_events_organizers_map">
        <querytext>
	delete from events_organizers_map
	 where role_id = :role_id
	   and event_id = :event_id
        </querytext>
    </fullquery>

    <fullquery name="events::organizer::users_get_options.users">
	<querytext>
         select distinct
                u.first_names || ' ' || u.last_name as name,
                u.user_id
	   from cc_users u	
	  order by name
	</querytext>
    </fullquery>

    <fullquery name="events::organizer::organizer_exists_p.check_events_organizers_map">
        <querytext>
	select * from events_organizers_map
	 where role_id = :role_id
	   and event_id = :event_id
        </querytext>
    </fullquery>

</queryset>



