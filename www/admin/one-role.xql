<?xml version="1.0"?>
<queryset>

    <fullquery name="select_activity_role_mappings">
        <querytext>
	select aa.activity_id, aa.name
          from events_activities ea, events_org_role_activity_map eoram,
		acs_activities aa
         where aa.activity_id = ea.activity_id
           and ea.activity_id = eoram.activity_id
           and eoram.role_id = :role_id
	 order by aa.name asc
        </querytext>
    </fullquery>

    <fullquery name="select_event_role_mappings">
        <querytext>
	select ee.event_id, aa.name,
	       to_char(t.start_date, 'Month DD, YYYY HH12:MI PM') as pretty_start_date,
	       to_char(t.end_date, 'Month DD, YYYY HH12:MI PM') as pretty_end_date
          from events_events ee, events_org_role_event_map eorem,
               acs_events ae, acs_activities aa, timespans s, time_intervals t
         where ee.event_id = eorem.event_id
           and eorem.event_id = ae.event_id
	   and aa.activity_id = ae.activity_id
	   and ae.timespan_id = s.timespan_id
	   and s.interval_id = t.interval_id
	   and eorem.role_id = :role_id
	 order by aa.name asc
        </querytext>
    </fullquery>

</queryset>
