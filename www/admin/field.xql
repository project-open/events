<?xml version="1.0"?>
<queryset>

    <fullquery name="select_activity_custom_field_mappings">
        <querytext>
	select aa.activity_id, aa.name
          from events_activities ea, events_def_actvty_attr_map edaam,
		acs_activities aa
         where aa.activity_id = ea.activity_id
           and ea.activity_id = edaam.activity_id
           and edaam.attribute_id = :attribute_id
	 order by aa.name asc
        </querytext>
    </fullquery>

    <fullquery name="select_event_custom_field_mappings">
        <querytext>
	select ee.event_id, aa.name,
	       to_char(t.start_date, 'fmMonth DD, YYYY, HH12:MI PM') as pretty_start_date,
	       to_char(t.end_date, 'fmMonth DD, YYYY, HH12:MI PM') as pretty_end_date
          from events_events ee, events_event_attr_map eeam,
               acs_events ae, acs_activities aa, timespans s, time_intervals t
         where ee.event_id = eeam.event_id
           and eeam.event_id = ae.event_id
	   and aa.activity_id = ae.activity_id
	   and ae.timespan_id = s.timespan_id
	   and s.interval_id = t.interval_id
	   and eeam.attribute_id = :attribute_id
	 order by aa.name asc
        </querytext>
    </fullquery>

</queryset>
