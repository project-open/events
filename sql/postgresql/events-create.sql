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

-- event venues
\i events-venues-create.sql
\i events-venues-package-create.sql

-- events and activities
\i events-events-create.sql
\i events-activities-create.sql
\i events-activities-package-create.sql

-- venue hierarchy and connections
\i events-venues-hc-create.sql

-- event prices
\i events-prices-create.sql

-- event registrations and orders
\i events-orders-create.sql
\i events-orders-package-create.sql
\i events-registrations-create.sql
\i events-registrations-package-create.sql

-- custom fields
\i events-attributes-create.sql

-- events package (references custom fields)
\i events-events-package-create.sql

-- event organizers
\i events-organizers-create.sql

