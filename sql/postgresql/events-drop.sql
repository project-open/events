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

-- event organizers
\i events-organizers-drop.sql

-- custom fields
\i events-attributes-drop.sql

-- venue hierarchy and connections
\i events-venues-hc-drop.sql

-- events and activities
\i events-events-drop.sql
\i events-events-package-drop.sql
\i events-activities-drop.sql
\i events-activities-package-drop.sql

-- event registrations and orders
\i events-registrations-drop.sql
\i events-registrations-package-drop.sql
\i events-orders-drop.sql
\i events-orders-package-drop.sql

-- event prices
\i events-prices-drop.sql

-- event venues
\i events-venues-drop.sql
\i events-venues-package-drop.sql
