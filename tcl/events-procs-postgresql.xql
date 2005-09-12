<?xml version="1.0"?>
<queryset>

    <fullquery name="events::event::new.new_timespan">
        <querytext> 
        select timespan__new (
                :sql_start_date::timestamp,
                :sql_end_date::timestamp
        )
        </querytext>
    </fullquery>

    <fullquery name="events::event::new.new_acs_event">
        <querytext> 
	select acs_event__new (
                null,            
                null,            
                null,            
                null,            
                null,            
		:timespan_id,    
                :activity_id,     
		null,            
                'acs_event',     
                now(),           
                :creation_user,  
		:creation_ip,    
                :context_id             
	)
        </querytext>
    </fullquery>

    <fullquery name="events::event::new.new_event">
        <querytext> 
	select events_event__new (
		:event_id,
		:venue_id,
		:display_after,
		:max_people,
		:sql_reg_deadline::timestamp,
		:available_p,
		:deleted_p,
		:reg_cancellable_p,
		:reg_needs_approval_p,
		:contact_user_id,
		:refreshments_note,
		:av_note,
		:additional_note,
		:alternative_reg,
		:activity_id
	)
        </querytext>
    </fullquery>



    <fullquery name="events::event::get.select_event_info">
	<querytext>
	select a.activity_id, aa.name, aa.description, e.display_after, v.city, v.usps_abbrev,
	       v.venue_id, 
	               CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	                    THEN to_char(t.start_date, :date_format) || ' from ' || to_char(t.start_date, :time_format) || ' to ' || to_char(t.end_date, :time_format)
	                    ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
	               END as timespan,
	       to_char(e.reg_deadline, :date_format) || ' ' || to_char(e.reg_deadline, :time_format) as reg_deadline,
	       e.available_p, e.max_people,
	       e.refreshments_note, 
	       e.time_zone,
	       e.av_note,
	       e.additional_note, ae.timespan_id, a.detail_url,
                       CASE WHEN e.reg_cancellable_p THEN 'Yes'
                            ELSE 'No'
                       END as pretty_reg_cancellable_p,
                       CASE WHEN e.reg_needs_approval_p THEN 'Yes'
                            ELSE 'No'
                       END as pretty_reg_needs_approval_p,
	       e.reg_cancellable_p,
	       e.reg_needs_approval_p,
	       e.contact_user_id,
	       coalesce(u.email, '') as contact_email,
               (select count(*)
                from   events_events ee2,
                       acs_events ae2, 
                       timespans ts2,
                       time_intervals ti2
                where  ee2.event_id != e.event_id 
                and    ee2.available_p = 't'
                and    ae2.event_id = ee2.event_id
                and    ae2.activity_id = a.activity_id 
                and    ts2.timespan_id = ae2.timespan_id
                and    ti2.interval_id = ts2.interval_id
                and    ti2.start_date > current_timestamp
               ) as num_other_times
	  from acs_events ae, 
	       acs_activities aa,
	       events_activities a, 
	       events_venues v, 
	       timespans s, 
	       time_intervals t,
	       events_events e left join cc_users u on (e.contact_user_id = u.user_id)
	 where e.event_id = :event_id
	   and ae.event_id = :event_id
	   and ae.activity_id = a.activity_id
	   and a.activity_id = aa.activity_id
	   and v.venue_id = e.venue_id
	   and ae.timespan_id = s.timespan_id
	   and s.interval_id = t.interval_id
	</querytext>
    </fullquery>


    <fullquery name="events::event::edit.update_event">
	<querytext>
	update events_events
	   set venue_id = :venue_id,
	       max_people = :max_people,
	       reg_cancellable_p = :reg_cancellable_p,
	       reg_needs_approval_p = :reg_needs_approval_p,
	       contact_user_id = :contact_user_id,
	       display_after = :display_after,
	       reg_deadline = :sql_reg_deadline::timestamp
	 where event_id = :event_id
	</querytext>
    </fullquery>

    <fullquery name="events::event::edit.update_time_interval">
	<querytext>
	update time_intervals
	   set start_date = :sql_start_date::timestamp,
	       end_date = :sql_end_date::timestamp
	 where interval_id = :interval_id 
	</querytext>
    </fullquery>

    <fullquery name="events::events::delete.delete_event">
        <querytext>
	select
		events_event__del(:event_id);
        </querytext>
    </fullquery>

    <fullquery name="events::event::toggle_available_p.toggle">
	<querytext>
	update events_events 
           set available_p = util__logical_negation(available_p) 
         where event_id = :event_id
	</querytext>
    </fullquery>

    <fullquery name="events::event::verify_bulk_mail_reminder.convert_to_timestamp_the_db_likes">
        <querytext>
        select to_timestamp(:bulk_mail_send_date, 'DDD YYYY HH24:MI:SS') as bulk_mail_send_date
        </querytext>
    </fullquery>

    <fullquery name="events::event::verify_bulk_mail_reminder.update_bulk_mail">
        <querytext>
        update bulk_mail_messages 
           set send_date = to_timestamp(:bulk_mail_send_date, :bulk_mail_date_format),
               subject = :subject,
               message = :message,
               from_addr = :from_addr
         where bulk_mail_id = :bulk_mail_id
	</querytext>
    </fullquery>

    <fullquery name="events::event::verify_bulk_mail_reminder.check_emails">
        <querytext>
	$query limit 1
 	</querytext>
    </fullquery>

	<fullquery name="events::event::get_stats.select_event_stats">
		<querytext>
         select t.count as total_interested, ee.max_people,
                ee.max_people as max_people,
                a.count as approved,
                p.count as pending,
                w.count as waiting,
                c.count as canceled, v.venue_id
           from (select count(*) as count from events_registrations where event_id = :event_id and reg_state = 'approved') a,  
                (select count(*) as count from events_registrations where event_id = :event_id and reg_state = 'pending') p,
                (select count(*) as count from events_registrations where event_id = :event_id and reg_state = 'waiting') w,
                (select count(*) as count from events_registrations where event_id = :event_id and reg_state = 'canceled') c,
                (select count(*) as count from events_registrations where event_id = :event_id and reg_state <> 'canceled') t,
                 events_events ee, events_venues v
          where ee.event_id = :event_id and ee.venue_id = v.venue_id
		</querytext>
	</fullquery>

</queryset>
