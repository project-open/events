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

drop function events_event__delete (integer);
drop function events_event__name(integer);
drop function events_event__new (integer,integer,varchar,integer,timestamp,boolean,boolean,boolean,boolean,integer,varchar,varchar,varchar,varchar,integer);
