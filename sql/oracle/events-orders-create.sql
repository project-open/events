--
-- The Events Package
--
-- @author Michael Steigman (michael@steigman.net)
-- @version $Id$
--
-- This package was originally written by Bryan Che and Phillip Greenspun
--
-- GNU GPL v2
--

-- Order Object Type

declare
begin

    acs_object_type.create_type(
        object_type => 'events_order',
        pretty_name => 'Order',
        pretty_plural => 'Orders',
        supertype => 'acs_object',
        table_name => 'events_orders',
        id_column => 'order_id'
    );

end;
/
show errors;

-- Table to hold additional attributes
create table events_orders (
       order_id		constraint events_orders_order_id_fk 
                        references acs_objects
                        constraint events_orders_order_id_pk
                        primary key,
       --       ec_order_id	integer references ec_orders,
       -- the person who made the order
       user_id		integer
                        constraint events_orders_user_id_fk 
                        references users,
       paid_p		char(1) default null check (paid_p in ('t', 'f', null)),
       payment_method	varchar(50),
       confirmed_date	date,
       price_charged	number,
       -- the date this registration was refunded, if it was refunded
       refunded_date	date,
       price_refunded	number
);

