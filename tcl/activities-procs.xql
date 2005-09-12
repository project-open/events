<?xml version="1.0"?>
<queryset>

    <fullquery name="events::activity::edit.update_acs_activities">
        <querytext>
	update acs_activities
           set name= :name,
               description= :description,
               html_p= :html_p
         where activity_id = :activity_id
        </querytext>
    </fullquery>

    <fullquery name="events::activity::edit.update_events_activities">
        <querytext>
	update events_activities
           set available_p = :available_p,
	       detail_url = :detail_url,
	       default_contact_user_id = :default_contact_user_id
         where activity_id = :activity_id
        </querytext>
    </fullquery>

    <fullquery name="events::activity::get_creator.select_creator_info">
	<querytext>
	 select u.first_names || ' ' || u.last_name as name,
		u.email as email
	   from acs_objects ao, cc_users u
	  where ao.object_id = :activity_id
	    and ao.creation_user = u.user_id
	</querytext>
    </fullquery>

   <fullquery name="events::activity::exists_p.exists_p_select">
	<querytext>
	select 1 
          from events_activities 
         where activity_id = :activity_id
           and package_id = :package_id
	</querytext>
   </fullquery>

   <fullquery name="events::activity::get_stats.select_activity_stats">
    	<querytext>
     select a.count as approved,
            p.count as pending,
            w.count as waiting,
            c.count as canceled
       from (select count(*) as count 
              from events_registrations er, acs_events ae 
              where ae.activity_id = :activity_id and ae.event_id = er.event_id and er.reg_state = 'approved') a,  
            (select count(*) as count 
               from events_registrations er, acs_events ae 
              where ae.activity_id = :activity_id and ae.event_id = er.event_id and er.reg_state = 'pending') p,
            (select count(*) as count 
               from events_registrations er, acs_events ae 
              where ae.activity_id = :activity_id and ae.event_id = er.event_id and er.reg_state = 'waiting') w,
            (select count(*) as count 
               from events_registrations er, acs_events ae 
              where ae.activity_id = :activity_id and ae.event_id = er.event_id and er.reg_state = 'canceled') c
    	</querytext>
    </fullquery>

</queryset>

