<?xml version="1.0"?>
<queryset>
    <fullquery name="select_available_activities">
        <querytext>
  select a.activity_id, a.name, ea.available_p
    from events_activities ea, acs_activities a
   where ea.activity_id = a.activity_id
     and package_id = :package_id
     and ea.available_p = 't'
   order by name asc
        </querytext>
    </fullquery>
    <fullquery name="select_unavailable_activities">
        <querytext>
  select a.activity_id, a.name, ea.available_p
    from events_activities ea, acs_activities a
   where ea.activity_id = a.activity_id
     and package_id = :package_id
     and ea.available_p = 'f'
   order by name asc
        </querytext>
    </fullquery>
</queryset>
