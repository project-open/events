<?xml version="1.0"?>
<queryset>

    <fullquery name="select_org_roles">
        <querytext>
	select role, eor.role_id, public_role_p,
                CASE when public_role_p = 't' then ' (public role)'
                        ELSE ''
                END 
	  from events_organizer_roles eor, events_org_role_activity_map eoram
	 where eoram.activity_id = :activity_id
	   and eoram.role_id = eor.role_id
	 order by role 
        </querytext>
    </fullquery>

    <fullquery name="select_activity_events">
        <querytext>
	select CASE WHEN to_char(t.start_date, 'YYYY-MM-DD') = to_char(t.end_date, 'YYYY-MM-DD') 
	            THEN to_char(t.start_date, :date_format) || ' (' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :time_format) || ')'
	            ELSE to_char(t.start_date, :date_format) || ' ' || to_char(t.start_date, :time_format) || ' - ' || to_char(t.end_date, :date_format) || ' ' || to_char(t.end_date, :time_format)
	       END as timespan,
               coalesce(e.name, a.name) as name,	 
               e.event_id,
               v.city,
               v.usps_abbrev
	  from acs_activities a,
	       acs_events e,
	       events_activities ea,
	       events_events ee,
	       timespans s,
	       time_intervals t,
	       events_venues v
	 where e.timespan_id = s.timespan_id
	   and s.interval_id = t.interval_id
	   and e.activity_id = a.activity_id
	   and a.activity_id = ea.activity_id
	   and e.activity_id = :activity_id
	   and e.event_id = ee.event_id
	   and v.venue_id = ee.venue_id
	   and ee.available_p = 't'
	   and ea.package_id = :package_id
	 order by t.start_date
        </querytext>
    </fullquery>

</queryset>
