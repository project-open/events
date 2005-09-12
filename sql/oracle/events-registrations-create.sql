--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was orinally written by Bryan Che and Phillip Greenspun
--
-- GNU GPL v2
--

--
-- Registration Object Type
--
declare
begin

    acs_object_type.create_type(
        object_type => 'events_registration',
        pretty_name => 'Registration',
        pretty_plural => 'Registrations',
        supertype => 'acs_object',
        table_name => 'events_registrations',
        id_column => 'reg_id'
    );

end;
/
show errors;


-- declare 
--         attr_id acs_attributes.attribute_id%TYPE; 
-- begin
-- 	--
-- 	-- events_registration foundation attributes
-- 	--
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'reg_state', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Registration State', 
--                 pretty_plural   =>      'Registration States'
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'shipped_date', 
--                 datatype        =>      'date',
--                 pretty_name     =>      'Shipped Date', 
--                 pretty_plural   =>      'Shipped Dates'
--         );
-- 
-- 	--
-- 	-- create built-in user-visible registration attributes
-- 	--
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'org', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Organization', 
--                 pretty_plural   =>      'Organizations',
-- 		sort_order	=>	1
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'title_at_org', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Title', 
--                 pretty_plural   =>      'Titles',
-- 		sort_order	=>	2
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'attending_reason', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Reason for attending', 
--                 pretty_plural   =>      'Reasons for attending',
-- 		sort_order	=>	3
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'where_heard', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Where did you hear about this activity?', 
--                 pretty_plural   =>      'Where did you hear about these activities?',
-- 		sort_order	=>	4
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'need_hotel_p', 
--                 datatype        =>      'boolean',
--                 pretty_name     =>      'Do you need a hotel?', 
--                 pretty_plural   =>      'Do you need a hotel?', 
-- 		sort_order	=>	5
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'need_car_p', 
--                 datatype        =>      'boolean',
--                 pretty_name     =>      'Do you need a car?', 
--                 pretty_plural   =>      'Do you need a car?', 
-- 		sort_order	=>	6
--         );
-- 
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'need_plane_p', 
--                 datatype        =>      'boolean',
--                 pretty_name     =>      'Do you need a plane ticket?', 
--                 pretty_plural   =>      'Do you need a plane ticket?', 
-- 		sort_order	=>	7
--         );
-- 
-- 	-- no sort order - comments will always be last
--         attr_id := acs_attribute.create_attribute ( 
--                 object_type     =>      'events_registration', 
--                 attribute_name  =>      'comments', 
--                 datatype        =>      'string',
--                 pretty_name     =>      'Comments', 
--                 pretty_plural   =>      'Comments'
--         );
-- 
-- end;
-- /
-- show errors;
-- 
create table events_registrations(
        -- Goes into table at confirmation time:
	reg_id		integer not null primary key,
        event_id        integer not null references events_events,
--	order_id	integer not null references events_orders,
--	price_id	integer not null references events_prices,
	-- the person registered for this reg_id (may not be the person
	-- who made the order)
	user_id		integer not null references users,
	-- reg_states: pending, shipped, canceled, waiting
	--pending: waiting for approval
	--shipped: registration all set 
	--canceled: registration canceled
	--waiting: registration is wait-listed
	reg_state	varchar(50) not null check (reg_state in ('pending', 'approved', 'canceled',  'waiting')),
	-- when the registration was made
	--	reg_date	date,
	-- when the registration was approved
	approval_date	date,
--	org		varchar(500),
--	title_at_org	varchar(500),
--	attending_reason  clob,
--	where_heard	varchar(4000),
	-- does this person need a hotel?
--        need_hotel_p	char(1) default 'f' check (need_hotel_p in ('t', 'f')),
	-- does this person need a rental car?
--        need_car_p	char(1) default 'f' check (need_car_p in ('t', 'f')),
	-- does this person need airfare?
--	need_plane_p	char(1) default 'f' check (need_plane_p in ('t', 'f')),
	comments	varchar(4000)
);


--
-- Indexes
-- 

-- removed price_id from index - 7/19/02
create index evnt_reg_idx on events_registrations(reg_id, user_id, reg_state);

-- need this index for speeding up /events/admin/order-history-one.tcl
--create index users_last_name_idx on users(lower(last_name), last_name, first_names, email, user_id);

--
-- Triggers
--

-- trigger for recording when a registration ships
create or replace trigger event_ship_date_trigger
before insert or update on events_registrations
for each row
when (old.reg_state <> 'approved' and new.reg_state = 'approved')
begin
	:new.approval_date := sysdate;
end;
/
show errors

--
-- Views
--
-- 
-- create or replace view events_reg_not_canceled
-- as 
-- select * 
-- from events_registrations
-- where reg_state <> 'canceled';
-- 
-- create or replace view events_reg_canceled
-- as 
-- select * 
-- from events_registrations
-- where reg_state = 'canceled';
-- 
-- create or replace view events_reg_shipped
-- as
-- select *
-- from events_registrations
-- where reg_state = 'shipped';
-- 
-- create a view that shows order states based upon each order's 
-- registrations.  The order states are:
-- void: All registrations canceled
-- incomplete: This order is not completely fulfilled--some registrations
-- are either canceled, waiting, or pending
-- fulfilled: This order is completely fulfilled
-- create or replace view events_orders_states 
-- as
-- select  o.*,
-- o_states.order_state
-- from events_orders o,
--  (select
--  order_id,
--  decode (floor(avg (decode (reg_state, 
--  		   'canceled', 0,
-- 		   'waiting', 1,
-- 		   'pending', 2,
-- 		   'shipped', 3,
-- 		   0))),
-- 	     0, 'canceled',
-- 	     1, 'incomplete',
-- 	     2, 'incomplete',
-- 	     3, 'fulfilled',
-- 	     'void') as order_state
--  from events_registrations
-- group by order_id) o_states
--where o_states.order_id = o.order_id;


