<?xml version="1.0"?>
<queryset>

	<fullquery name="select_reg_history">
		<querytext>
select CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	    THEN to_char(t.start_date, :date_format) || ' (' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format) || ')'
	    ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
       END as timespan,
       aa.name, ae.activity_id, ae.event_id, reg_id, ev.venue_name, er.reg_state
  from acs_events ae,
       acs_activities aa,
       events_registrations er,
       timespans s,
       time_intervals t,
       events_venues ev,
       events_events ee,
       events_activities ea
 where er.user_id = :user_id
   and er.event_id = ae.event_id
   and ae.activity_id = aa.activity_id
   and ae.timespan_id = s.timespan_id
   and s.interval_id = t.interval_id
   and ee.event_id = ae.event_id
   and ee.venue_id = ev.venue_id
   and aa.activity_id = ea.activity_id
   and ea.package_id = :package_id
		</querytext>
	</fullquery>

	<fullquery name="select_user_info">
		<querytext>
                select first_names || ' ' || last_name as user_name, email as user_email
                  from persons, parties 
                 where person_id = :user_id 
                   and person_id = party_id
		</querytext>
	</fullquery>

</queryset>
