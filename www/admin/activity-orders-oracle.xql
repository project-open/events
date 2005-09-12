<?xml version="1.0"?>
<queryset>

	<fullquery name="select_activity_members">
		<querytext>
                select er.reg_id,
                       person.name(er.user_id) as name,
                       er.user_id,
                       pa.email,
                       er.reg_state,
                       to_char(ao.creation_date, :date_format) || ' ' || to_char(ao.creation_date, :time_format) as creation_date,
                       ae.event_id,
                       ev.venue_name,
                       CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	                    THEN to_char(t.start_date, :date_format) || ' (' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format) || ')'
	                    ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
	               END as timespan
                  from events_registrations er,
                       parties pa,
                       acs_objects ao,
                       acs_events ae,
                       events_venues ev,
                       events_events ee,
 		       timespans s,
	 	       time_intervals t
                 where er.user_id = pa.party_id
                   and ae.activity_id = :activity_id
                   and ae.event_id = er.event_id
                   and ae.event_id = ee.event_id
                   and ee.venue_id = ev.venue_id
                   and er.reg_state <> 'canceled'
                   and er.reg_id = ao.object_id
                   and ae.timespan_id = s.timespan_id
		   and s.interval_id = t.interval_id
              order by creation_date
		</querytext>
	</fullquery>

	<fullquery name="select_specific_reg_type">
		<querytext>
                select er.reg_id,
                       person.name(er.user_id) as name,
                       er.user_id,
                       pa.email,
                       er.reg_state,
                       to_char(ao.creation_date, :date_format) || ' ' || to_char(ao.creation_date, :time_format) as creation_date,
                       ae.event_id,
                       ev.venue_name,
                       CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	                    THEN to_char(t.start_date, :date_format) || ' (' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format) || ')'
	                    ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
	               END as timespan
                  from events_registrations er,
                       parties pa,
                       acs_objects ao,
                       acs_events ae,
                       events_venues ev,
                       events_events ee,
 		       timespans s,
	 	       time_intervals t
                 where er.user_id = pa.party_id
                   and ae.activity_id = :activity_id
                   and ae.event_id = er.event_id
                   and ae.event_id = ee.event_id
                   and ee.venue_id = ev.venue_id
                   and er.reg_state = :specific_reg_type
                   and er.reg_id = ao.object_id
                   and ae.timespan_id = s.timespan_id
		   and s.interval_id = t.interval_id
              order by creation_date
		</querytext>
	</fullquery>

</queryset>
