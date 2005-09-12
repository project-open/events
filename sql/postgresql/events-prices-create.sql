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

-- Not implemented yet


--
-- IS THIS HOW TO CREATE A SEQUENCE ?????
--
create sequence events_price_id_sequence;

create table events_prices (
    price_id            integer primary key,
    event_id            integer not null references events_events,
    -- e.g., "Developer", "Student"
    description         varchar(100) not null,
    -- we also store the price here too in case someone doesn't want
    -- to use the ecommerce module but still wants to have prices
    price		numeric not null,
    -- This is for hooking up to ecommerce.	
    -- Each product is a different price for this event.  For example,
    -- student price and normal price products for an event.
--  product_id          integer references ec_products,
    -- prices may be different for early, normal, late, on-site
    -- admission,
    -- depending on the date
    expire_date	      timestamptz not null,
    available_date    timestamptz not null
);

create index evnt_price_idx on events_prices(price_id, event_id);
