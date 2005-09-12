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

-- The Registration Package
select define_function_args('events_registration__new','reg_id,event_id,user_id,reg_state,comments,creation_date,creation_user,creation_ip,context_id');

create function events_registration__new (integer,integer,integer,varchar,varchar,timestamp,integer,varchar,integer)
returns integer as '
declare
      p_reg_id             alias for $1;      -- default null
      p_event_id           alias for $2;
      p_user_id	           alias for $3;	
      p_reg_state	   alias for $4;
      p_comments           alias for $5;				
      p_creation_date      alias for $6;      -- default now()				
      p_creation_user      alias for $7;      	
      p_creation_ip        alias for $8;      
      p_context_id         alias for $9;      -- default null	
      v_reg_id             integer;
begin
        v_reg_id := acs_object__new (
                null,
                ''events_registration'',
                now(),
                p_creation_user,
                p_creation_ip,
                p_event_id
        );


      insert into events_registrations
      (reg_id, event_id, user_id, reg_state, comments)
      values
      (v_reg_id, p_event_id, p_user_id, p_reg_state, p_comments);

      return v_reg_id;

end;' language 'plpgsql';




-- select define_function_args('events_registration__name','registration_id');
-- 
-- create function events_registration__name(integer)
-- returns varchar as '
-- declare
--     p_registration_id                      alias for $1;
-- begin
--     return p_registration_id as events_registration_name;
-- end;
-- ' language 'plpgsql';




select define_function_args('events_registration__delete','reg_id');

create function events_registration__delete (integer)
returns integer as '
declare
  p_reg_id				alias for $1;
begin

	delete from events_registrations
		   where reg_id = p_reg_id;

	raise NOTICE ''Deleting note...'';
	PERFORM acs_object__delete(p_reg_id);

	return 0;

end;' language 'plpgsql';








 


















