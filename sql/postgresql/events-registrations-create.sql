-- 
-- The Events Package
-- 
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
-- 
-- This package was orinally written by Bryan Che and Philip Greenspun
-- 
-- GNU GPL v2
-- 
   
-- 
-- Registration Object Type
--

create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''events_registration'',	-- object_type
	''Registration'',		-- pretty_name
	''Registrations'',		-- pretty_plural
	''acs_object'',			-- supertype
	''events_registrations'',	-- table_name
	''reg_id'',			-- id_column
	null,           		-- package_name
	''f'',				-- abstract_p
	null,				-- type_extensions_table
	null                     	-- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();







-- create function inline_1 ()
-- returns integer as '
-- begin
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''reg_state'',		        -- attribute_name
-- 	  ''string'',			        -- datatype
-- 	  ''Registration State'',		-- pretty_name
-- 	  ''Registration States'',		-- pretty_plural
--   	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  null,					-- sort_order
-- 	  ''type_specific'',	-- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''shipped_date'',			-- attribute_name
--   	  ''string'',				-- datatype
-- 	  ''Shipped Date'',			-- pretty_name
-- 	  ''Shipped Dates'',			-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  null,					-- sort_order
-- 	  ''type_specific'',	-- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
-- --
-- -- create built-in user-visible registration attributes
-- 
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''org'',				-- attribute_name
-- 	  ''string'',				-- datatype
-- 	  ''Organization'',			-- pretty_name
-- 	  ''Organizations'',			-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
--   	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''1'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type                         
-- 	  ''title_at_org'',			-- attribute_name
-- 	  ''string'',				-- datatype
-- 	  ''Title'',			        -- pretty_name
-- 	  ''Titles'',			        -- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''2'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''attending_reason'',			-- attribute_name
-- 	  ''string'',				-- datatype
-- 	  ''Reason for attending'',		-- pretty_name
-- 	  ''Reasons for attending'',		-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''3'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		        	-- object_type
-- 	  ''where_hear'',			                -- attribute_name
-- 	  ''string'',				                -- datatype
-- 	  ''Where did you hear about this activity?'',		-- pretty_name
-- 	  ''Where did you hear about these activities'',	-- pretty_plural
-- 	  null,					                -- table_name
-- 	  null,					                -- column_name
-- 	  null,					                -- default_value
-- 	  1,					                -- min_n_values
-- 	  1,					                -- max_n_values
-- 	  ''4'',				                -- sort_order
-- 	  ''type_specific'',	                                -- storage
-- 	  ''f''					                -- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''need_hotel_p'',			-- attribute_name
-- 	  ''boolean'',				-- datatype
-- 	  ''Do you need a hotel?'',		-- pretty_name
-- 	  ''Do you need a hotel?'',		-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''5'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''need_car_p'',		        -- attribute_name
-- 	  ''boolean'',				-- datatype
-- 	  ''Do you need a car?'',		-- pretty_name
-- 	  ''Do you need a car?'',		-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''6'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',		-- object_type
-- 	  ''need_plane_p'',			-- attribute_name
-- 	  ''boolean'',				-- datatype
-- 	  ''Do you need a plane ticket?'',	-- pretty_name
-- 	  ''Do you need a plane ticket?'',	-- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  ''7'',				-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
-- 
-- -- no sort order - comments will always be last
-- 
--     PERFORM acs_attribute__create_attribute (
-- 	  ''events_registration'',	        -- object_type
-- 	  ''comments'',				-- attribute_name
-- 	  ''string'',				-- datatype
-- 	  ''Comments'',			        -- pretty_name
-- 	  ''Comments'',			        -- pretty_plural
-- 	  null,					-- table_name
-- 	  null,					-- column_name
-- 	  null,					-- default_value
-- 	  1,					-- min_n_values
-- 	  1,					-- max_n_values
-- 	  null,					-- sort_order
-- 	  ''type_specific'',	                -- storage
-- 	  ''f''					-- static_p
-- 	);
-- 
--     return 0;
-- end;' language 'plpgsql';
-- 
-- select inline_1 ();
-- 
-- drop function inline_1 ();
-- 
-- 
-- 

create table events_registrations(
 	reg_id		integer not null primary key,
        event_id        integer not null references events_events,
--	order_id	integer not null references events_orders,
--	price_id	integer not null references events_prices,
	-- the person registered for this reg_id (may not be the person who made the order - we haven't implemented this)
	user_id		integer not null references users,
	-- reg_states: pending, approved, canceled, waiting
	--pending: waiting for approval
	--approved: registration all set 
	--canceled: registration canceled
	--waiting: registration is wait-listed
	reg_state	varchar(50) not null check (reg_state in ('pending', 'approved', 'canceled',  'waiting')),
	-- when the registration was made
	--	reg_date	date,
	-- when the registration was approved

	approval_date	timestamptz,
--	org		varchar(500),
--	title_at_org	varchar(500),
--	attending_reason  text,
--	where_heard	varchar(4000),
	-- does this person need a hotel?
--        need_hotel_p	boolean default 'f',
	-- does this person need a rental car?
--        need_car_p	boolean default 'f',
	-- does this person need airfare?
--	need_plane_p	boolean default 'f',
	comments	text
);


--
-- Indexes
-- 

-- removed price_id from index - 7/19/02
-- mgeddert - removed org and title at org from index - we will use survey service contracts for this
create index evnt_reg_idx on events_registrations(reg_id, user_id,reg_state);

-- need this index for speeding up /events/admin/order-history-one.tcl
--create index users_last_name_idx on users(lower(last_name), last_name, first_names, email, user_id);

--
-- Triggers
--

-- trigger for recording when a registration is approved ???????????
--
CREATE FUNCTION event_ship_date_trigger_proc () 
RETURNS trigger AS '
BEGIN
        IF NEW.reg_state = ''approved''
	THEN
           NEW.approval_date := now();
        END IF;
	RETURN NEW;
END;
' LANGUAGE 'plpgsql';


create trigger event_ship_date_trigger 
before insert or update on events_registrations
for each row execute procedure event_ship_date_trigger_proc();




-- Views
--
-- mgeddert: THESE VIEWS SEEM COMPELTELY UNNECESSARY
--
--create view events_reg_not_canceled as 
--select * from events_registrations
--where reg_state <> 'canceled';
--
--create view events_reg_canceled as 
--select * from events_registrations
--where reg_state = 'canceled';
--
--create view events_reg_approved as
--select * from events_registrations
--where reg_state = 'approved';
--
-- create a view that shows order states based upon each order's 
-- registrations.  The order states are:
-- void: All registrations canceled
-- incomplete: This order is not completely fulfilled--some registrations
-- are either canceled, waiting, or pending
-- fulfilled: This order is completely fulfilled
--
--
--
--
--
--
--
--
--
--
--
--create view events_orders_states  as
--select o.*, o_states.order_state
--from events_orders o, (
--	  SELECT order_id, CASE (floor(avg( 
--				CASE reg_state
--	                    		WHEN 'canceled' THEN 0
--        	            		WHEN 'waiting' THEN 1
--                	    		WHEN 'pending' THEN 2
--                    			WHEN 'approved' THEN 3
--	                    	ELSE 0
--				END )))
--				WHEN 0 THEN 'canceled'
--				WHEN 1 THEN 'incomplete'
--				WHEN 2 THEN 'incomplete'
--				WHEN 3 THEN 'fulfilled'
--				ELSE 'void'
--				END
--				 as order_state
--           FROM events_registrations
--           GROUP BY order_id ) o_states
--WHERE o_states.order_id = o.order_id;
--
--
--
--
