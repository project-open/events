<?xml version="1.0"?>

<queryset>
	<fullquery name="select_event_info">
		<querytext>
                select a.activity_id, 
                       e.event_id, 
                       aa.name, 
                       aa.description,
                       aa.html_p,
                       v.city, 
                       to_char(t.start_date,:date_format) as start_date_pretty,
	               CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	                    THEN to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format)
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
                 where a.package_id = :package_id
                   and ae.event_id = e.event_id 
                   and ae.activity_id = a.activity_id 
                   and a.activity_id = aa.activity_id 
                   and e.reg_deadline > sysdate 
                   and e.available_p <> 'f' 
                   and v.venue_id = e.venue_id 
                   and ae.timespan_id = s.timespan_id 
                   and s.interval_id = t.interval_id 
                   and acs_permission.permission_p(
                       e.event_id,
                       nvl(:user_id, acs.magic_object_id('the_public')),
                       'read') = 't'
                 order by t.start_date
		</querytext>
	</fullquery>
</queryset>
