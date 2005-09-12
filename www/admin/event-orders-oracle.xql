<?xml version="1.0"?>
<queryset>

	<fullquery name="select_event_members">
		<querytext>
                select er.reg_id, person.name(er.user_id) as name, er.user_id,
                       pa.email, er.reg_state, ao.creation_date
                  from events_registrations er, parties pa, acs_objects ao 
                 where er.user_id = pa.party_id
                   and er.event_id = :event_id
                   and reg_state <> 'canceled'
                   and er.reg_id = ao.object_id
		</querytext>
	</fullquery>

	<fullquery name="select_specific_reg_type">
		<querytext>
                select er.reg_id, person.name(er.user_id) as name, er.user_id,
                       pa.email, er.reg_state, ao.creation_date
                  from events_registrations er, parties pa, acs_objects ao
                 where er.user_id = pa.party_id
                   and er.event_id = :event_id
                   and reg_state = :specific_reg_type
                   and er.reg_id = ao.object_id
		</querytext>
	</fullquery>

</queryset>
