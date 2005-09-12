<?xml version="1.0"?>
<queryset>
    <fullquery name="select_upcoming_events">
        <querytext>
	select e.event_id, v.city, t.start_date,
	       CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	            THEN to_char(t.start_date, :date_format) || ' (' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format) || ')'
	            ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
	       END as timespan
	  from acs_events ae, 
	       acs_activities aa,
               dual,
	       events_events e, 
	       events_activities a, 
	       events_venues v, 
	       timespans s, 
	       time_intervals t
	 where aa.activity_id = :activity_id
	   and aa.activity_id = a.activity_id
	   and a.activity_id = ae.activity_id
	   and ae.event_id = e.event_id
	   and e.available_p <> 'f'
	   and t.start_date > sysdate
	   and v.venue_id = e.venue_id
	   and ae.timespan_id = s.timespan_id
	   and s.interval_id = t.interval_id
           and acs_permission__permission_p(
                       e.event_id,
                       coalesce(:user_id, acs__magic_object_id('the_public')),
                       'read') = 't'
	  order by t.start_date
        </querytext>
    </fullquery>
</queryset>
                   
