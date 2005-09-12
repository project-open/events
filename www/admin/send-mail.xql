<?xml version="1.0"?>

<queryset>
    <fullquery name="select_activity_from_addr_count">
        <querytext>
        select count(*) as from_addr_count 
          from parties pa,
               events_activities ea
         where ea.default_contact_user_id = pa.party_id
           and ea.activity_id = :activity_id
            or pa.party_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_activity_from_addr">
        <querytext>
        select CASE WHEN ea.default_contact_user_id = pa.party_id AND ea.default_contact_user_id <> :user_id THEN pa.email || ' (the default contact for this activity)'
               ELSE pa.email END as from_addr, pa.email 
          from parties pa,
               events_activities ea
         where ea.default_contact_user_id = pa.party_id
           and ea.activity_id = :activity_id
            or pa.party_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_event_from_addr_count">
        <querytext>
        select count(*) as from_addr_count 
          from (select contact_user_id from events_events where event_id = :event_id) ee,
               parties pa
         where ee.contact_user_id = pa.party_id
            or pa.party_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_event_from_addr">
        <querytext>
        select CASE WHEN ee.contact_user_id = pa.party_id AND ee.contact_user_id <> :user_id THEN pa.email || ' (the default contact for this event)'
               ELSE pa.email END as from_addr, pa.email 
          from (select contact_user_id from events_events where event_id = :event_id) ee,
               parties pa
         where ee.contact_user_id = pa.party_id
            or pa.party_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_my_email_address">
        <querytext>
        select email as from_addr
          from parties
         where party_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="select_all_event_registrants">
        <querytext>
        select pa.email
          from parties pa,
               events_registrations er
         where er.user_id = pa.party_id
           and er.reg_state <> 'canceled'
           and event_id = '$event_id'
        </querytext>
    </fullquery>

    <fullquery name="select_event_reg_state_registrants">
        <querytext>
        select pa.email
          from parties pa,
               events_registrations er
         where er.user_id = pa.party_id
           and er.reg_state = '$to'
           and event_id = '$event_id'
        </querytext>
    </fullquery>

    <fullquery name="select_event_organizers">
        <querytext>
        select pa.email
          from parties pa,
               events_organizers eo
         where eo.user_id = pa.party_id
           and eo.event_id = '$event_id'
        </querytext>
    </fullquery>

    <fullquery name="select_activity_reg_state_future">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state = '$to'
           and t.start_date > sysdate 
         group by pa.email
        </querytext>
    </fullquery>

    <fullquery name="select_activity_all_future">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state <> 'canceled'
           and t.start_date > sysdate 
         group by pa.email
        </querytext>
    </fullquery>

    <fullquery name="select_activity_all_past">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state <> 'canceled'
           and t.start_date < sysdate 
         group by pa.email
        </querytext>
    </fullquery>

    <fullquery name="select_activity_reg_state_past">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state = '$to'
           and t.start_date < sysdate 
         group by pa.email
        </querytext>
    </fullquery>

    <fullquery name="select_activity_reg_state_all">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state = '$to'
         group by pa.email
        </querytext>
    </fullquery>

    <fullquery name="select_activity_all_all">
        <querytext>
        select pa.email
          from events_registrations er,
               parties pa,
               acs_events ae,
               timespans s,
               time_intervals t,
               dual
         where er.user_id = pa.party_id
           and ae.activity_id = '$activity_id'
           and ae.event_id = er.event_id
           and ae.timespan_id = s.timespan_id
           and s.interval_id = t.interval_id
           and er.reg_state <> 'canceled'
         group by pa.email
        </querytext>
    </fullquery>

</queryset>
