-- 
-- The Events Package
-- 
-- @author Matthew Geddert (geddert@yahoo.com)
-- @version $Id$
-- 
-- This package was originally written by Bryan Che and Philip Greenspun
-- 
-- GNU GPL v2
-- 

-- Order Package
 
select define_function_args('events_order__new','order_id,event_id,user_id,creation_date,creation_user,creation_ip,context_id');

create function events_order__new (integer,integer,integer,timestamp,integer,varchar,integer)
returns integer as '
declare
      p_order_id           alias for $1;      -- default null	
      p_event_id           alias for $2;
      p_user_id	           alias for $3;	
      p_creation_date      alias for $4;      -- default now()				
      p_creation_user      alias for $5;      	
      p_creation_ip        alias for $6;      
      p_context_id         alias for $7;      -- default null	
      v_order_id             integer;
begin
        v_order_id := acs_object__new (
                p_order_id,
                ''events_order'',
                p_creation_date,
                p_creation_user,
                p_creation_ip,
                coalesce(p_context_id, p_event_id)
        );


      insert into events_orders
      (order_id, user_id)
      values
      (v_order_id, p_user_id);

        return v_order_id;

end;' language 'plpgsql';




-- select define_function_args('events_order__name','order_id');
-- 
-- create function events_order__name(integer)
-- returns varchar as '
-- declare
--     p_order_id                      alias for $1;
-- begin
--     return p_order_id as event_order_name;
-- end;
-- ' language 'plpgsql';
-- 





select define_function_args('events_order__delete','order_id');

create function events_order__delete (integer)
returns integer as '
declare
  p_order_id				alias for $1;
begin

	delete from events_orders
		   where order_id = p_order_id;

	raise NOTICE ''Deleting note...'';
	PERFORM acs_object__delete(p_order_id);

	return 0;

end;' language 'plpgsql';
