--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was originally written by Bryan Che and Philip Greenspun
--
-- GNU GPL v2
--

--
-- Event Object Type
--
declare
begin

    acs_object_type.create_type(
        object_type => 'events_event',
        pretty_name => 'Event',
        pretty_plural => 'Events',
        supertype => 'acs_event',
        table_name => 'events_events',
        id_column => 'event_id'
    );

end;
/
show errors

declare 
        attr_id acs_attributes.attribute_id%TYPE; 
begin
        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'max_people', 
                datatype        =>      'integer',
                pretty_name     =>      'Max People', 
                pretty_plural   =>      'Max People'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'reg_deadline', 
                datatype        =>      'date',
                pretty_name     =>      'Registration Deadline', 
                pretty_plural   =>      'Registration Deadlines'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'available_p', 
                datatype        =>      'string',
                pretty_name     =>      'Available?', 
                pretty_plural   =>      'Available?'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'display_after', 
                datatype        =>      'string',
                pretty_name     =>      'Display After', 
                pretty_plural   =>      'Display After'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'av_note', 
                datatype        =>      'string',
                pretty_name     =>      'Audio/Visual Note', 
                pretty_plural   =>      'Audio/Visual Notes'
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'refreshments_note', 
                datatype        =>      'string',
                pretty_name     =>      'Refreshment Note', 
                pretty_plural   =>      'Refreshment Notes' 
        );

        attr_id := acs_attribute.create_attribute ( 
                object_type     =>      'events_event', 
                attribute_name  =>      'additional_note', 
                datatype        =>      'string',
                pretty_name     =>      'Additional Note', 
                pretty_plural   =>      'Additional Notes' 
        );
end;
/
show errors;


-- Each event has the super_type of ACS_EVENTS
-- Table events_events supplies additional information
create table events_events (
        event_id                integer 
                                constraint events_event_id_fk 
                                references acs_events
                                constraint events_event_id_pk
                                primary key,
        venue_id                integer 
                                constraint events_venue_id_fk 
                                references events_venues,
        display_after		varchar(4000),
	max_people		integer,
	contact_user_id		integer
				constraint events_cntct_usr_id_fk
				references users,
        reg_deadline		date not null,
	available_p		char(1) default 't' check (available_p in ('t', 'f')),
	deleted_p		char(1) default 'f' check (deleted_p in ('t', 'f')),
	reg_cancellable_p	char(1) default 't' check (reg_cancellable_p in ('t', 'f')),
	reg_needs_approval_p	char(1) default 'f' check (reg_needs_approval_p in ('t', 'f')),
	av_note			varchar(4000),
	refreshments_note	varchar(4000),
	additional_note		varchar(4000),
	alternative_reg		varchar(4000),
        bulk_mail_id            integer
                                constraint bulk_mail_id_fk
                                references bulk_mail_messages
);

comment on table events_events is '
	Table events_events supplies additional information for events_event type.
';

comment on column events_events.event_id is '
        Primary Key
';

comment on column events_events.display_after is '
        This field contains text that will be displayed to user 
	after registering for an event.
';

