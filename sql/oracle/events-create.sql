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
@ events-venues-create.sql
@ events-venues-package-create.sql

-- events and activities
@ events-events-create.sql
@ events-activities-create.sql

-- venue hierarchy and connections
@ events-venues-hc-create.sql

-- event prices
@ events-prices-create.sql

-- event registrations and orders
@ events-orders-create.sql
@ events-orders-package-create.sql
@ events-registrations-create.sql
@ events-registrations-package-create.sql

-- custom fields
@ events-attributes-create.sql

-- event organizers
@ events-organizers-create.sql

-- events package (references custom fields)
@ events-events-package-create.sql
@ events-activities-package-create.sql
