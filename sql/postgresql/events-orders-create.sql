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

-- Order Object Type


create function inline_0 ()
returns integer as '
begin
    PERFORM acs_object_type__create_type (
	''events_order'',		-- object_type
	''Order'',			-- pretty_name
	''Orders'',			-- pretty_plural
	''acs_object'',			-- supertype
	''events_orders'',		-- table_name
	''order_id'',			-- id_column
	null,		                -- package_name
	''f'',				-- abstract_p
	null,				-- type_extensions_table
	null                       	-- name_method
	);

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

-- Table to hold additional attributes
--
-- THE ORACLE CODE DIDN'T SAY ORDER_ID WAS AN INTEGER???? is this okay???? Does it need to be added???
--
create table events_orders (
       order_id		integer
			constraint events_orders_order_id_fk 
                        references acs_objects
                        constraint events_orders_order_id_pk
                        primary key,
       --       ec_order_id	integer references ec_orders,
       -- the person who made the order
       user_id		integer
                        constraint events_orders_user_id_fk 
                        references users,
       paid_p		boolean default null,
       payment_method	varchar(50),
       confirmed_date	timestamptz,
       price_charged	numeric,
       -- the date this registration was refunded, if it was refunded
       refunded_date	timestamptz,
       price_refunded	numeric
);

