<?xml version="1.0"?>
<queryset>

    <fullquery name="events::registration::get.select_registration_info">
	<querytext>
             select er.event_id,
                    er.user_id,
                    person.name(er.user_id) as user_name,
                    pa.email as user_email,
                    er.reg_state,
                    to_char(ao.creation_date, :date_format) || ' ' || to_char(ao.creation_date, :time_format) as creation_date,
	            to_char(er.approval_date, :date_format) || ' ' || to_char(er.approval_date, :time_format) as approval_date,
                    er.comments,
                    :url || site_node.url(sn.node_id) as package_url
               from events_registrations er,
                    parties pa,
                    acs_objects ao,
                    site_nodes sn
              where er.reg_id = :reg_id
                and sn.object_id = :package_id
                and er.reg_id = ao.object_id
                and er.user_id = pa.party_id
        </querytext>
    </fullquery>

    <fullquery name="events::registration::delete.delete_registration">
        <querytext>
	declare begin
		events_registration.del(:reg_id);
	end;
        </querytext>
    </fullquery>

    <fullquery name="events::registration::new_attribute.create_reg_attribute">
        <querytext>
	declare	begin
	:1 := acs_attribute.create_attribute (
		object_type => 'events_registration',
		attribute_name => :attribute_name,
		datatype => :datatype,
		pretty_name => :pretty_name,
		pretty_plural => :pretty_plural,
		storage => 'generic',	
		sort_order => :sort_order
	);
	end;
        </querytext>
    </fullquery>

    <fullquery name="events::registration::delete_attribute.drop_reg_attribute">
        <querytext>
	declare	begin
	acs_attribute.drop_attribute (
		object_type => 'events_registration',
		attribute_name => :attribute_name
	);
	end;
        </querytext>
    </fullquery>

</queryset>
