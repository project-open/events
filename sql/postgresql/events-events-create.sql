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

create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''events_event'',		-- object_type
	''Event'',			-- pretty_name
	''Events'',			-- pretty_plural
	''acs_event'',			-- supertype
	''events_events'',		-- table_name
	''event_id'',			-- id_column
	null,	                	-- package_name
	''f'',				-- abstract_p
	null,				-- type_extensions_table
	''events_event.name''	        -- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();








create function inline_1 ()
returns integer as '
begin
    PERFORM acs_attribute__create_attribute (
	  ''events_event'',		-- object_type
	  ''max_people'',		-- attribute_name
	  ''string'',			-- datatype
	  ''Max People'',		-- pretty_name
	  ''Max People'',		-- pretty_plural
	  null,				-- table_name
	  null,				-- column_name
	  null,				-- default_value
	  1,				-- min_n_values
	  1,				-- max_n_values
	  null,				-- sort_order
	  ''type_specific'',	        -- storage
	  ''f''				-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''reg_deadline'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Registration Deadline'',		-- pretty_name
	  ''Registrations Deadlines'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''available_p'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Available?'',			-- pretty_name
	  ''Available?'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''display_after'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Display After'',			-- pretty_name
	  ''Display After'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''av_note'',			        -- attribute_name
	  ''string'',				-- datatype
	  ''Audio/Visual Note'',		-- pretty_name
	  ''Audio/Visual Notes'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''refreshements_note'',		-- attribute_name
	  ''string'',				-- datatype
	  ''Refreshment Note'', 		-- pretty_name
	  ''Refreshment Notes'',		-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    PERFORM acs_attribute__create_attribute (
	  ''events_event'',			-- object_type
	  ''additional_note'',			-- attribute_name
	  ''string'',				-- datatype
	  ''Additional Note'',			-- pretty_name
	  ''Additional Notes'',			-- pretty_plural
	  null,					-- table_name
	  null,					-- column_name
	  null,					-- default_value
	  1,					-- min_n_values
	  1,					-- max_n_values
	  null,					-- sort_order
	  ''type_specific'',	-- storage
	  ''f''					-- static_p
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();













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
        reg_deadline		timestamptz not null,
	available_p		boolean default 't',
	deleted_p		boolean default 'f',
	reg_cancellable_p	boolean default 't',
	reg_needs_approval_p	boolean default 'f',
	av_note			varchar(4000),
	refreshments_note	varchar(4000),
	additional_note		varchar(4000),
	alternative_reg		varchar(4000),
        bulk_mail_id            integer
                                constraint bulk_mail_id_fk
                                references bulk_mail_messages,
	time_zone		integer references timezones(tz_id)
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

