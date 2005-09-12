<?xml version="1.0"?>
<queryset>

	<fullquery name="events::event::get_creator.select_creator_info">
		<querytext>
		 select u.first_names || ' ' || u.last_name as name,
			u.email as email
		   from acs_objects ao, cc_users u
		  where ao.object_id = :event_id
		    and ao.creation_user = u.user_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::edit.select_interval_id">
		<querytext>
		select t.interval_id
	          from time_intervals t, timespans s, acs_events ae
	         where ae.event_id = :event_id
		   and ae.timespan_id = s.timespan_id
		   and s.interval_id = t.interval_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::make_event_date.select_event_date">
		<querytext>
		select to_char($which_date,'$date_format')
		  from time_intervals t, timespans s
		 where s.timespan_id = :timespan_id
		   and t.interval_id = s.interval_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::make_event_date.select_reg_deadline">
		<querytext>
		select to_char(reg_deadline,'$date_format')
		  from events_events e
		 where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::edit_event_notes.update_event_notes">
		<querytext>
		update events_events
		   set refreshments_note = :refreshments_note,
		       av_note = :av_note,
		       additional_note = :additional_note
		 where event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::attachments_enabled_p.root_folder_exists_p">
		<querytext>
		select 1 from attachments_fs_root_folder_map
		 where package_id = :package_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::exists_p.exists_p_select">
		<querytext>
		select 1 
                  from events_events ee,
                       events_activities ea,
                       acs_events ae
                 where ee.event_id = :event_id
                   and ae.event_id = :event_id
                   and ae.activity_id = ea.activity_id
                   and ea.package_id = :package_id 
		</querytext>
	</fullquery>

	<fullquery name="events::event::reg_deadline_elapsed_p.reg_deadline_elapsed_p_select">
		<querytext>
		select 1 
                  from events_events ee,
                       dual
                 where ee.event_id = :event_id
                   and ee.reg_deadline < sysdate
		</querytext>
	</fullquery>

	<fullquery name="events::event::verify_bulk_mail_reminder.update_events_events_bulk_mail_id">
	        <querytext>
	        update events_events
	           set bulk_mail_id = :bulk_mail_id
	         where event_id = :event_id
	 	</querytext>
	</fullquery>

	<fullquery name="events::event::verify_bulk_mail_reminder.select_startdate_and_bulk_mail_id">
		<querytext>
	       select to_char(ti.start_date, 'DDD') as day_of_year, 
	              to_char(ti.start_date, 'YYYY') as year,
	              to_char(ti.start_date, 'HH24:MI:SS') as time,
	              ee.bulk_mail_id
	         from time_intervals ti, timespans ts, acs_events ae, events_events ee
	        where ti.interval_id = ts.interval_id
	          and ts.timespan_id = ae.timespan_id
	          and ae.event_id = :event_id 
	          and ee.event_id = :event_id
		</querytext>
	</fullquery>

	<fullquery name="events::event::verify_bulk_mail_reminder.select_approved_registrants">
	        <querytext>
	        select pa.email
	          from parties pa, events_registrations er
	         where er.user_id = pa.party_id
	           and er.reg_state = 'approved'
	           and event_id = '$event_id'
	        </querytext>
	</fullquery>

</queryset>

