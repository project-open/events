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

-- Each event can have custom fields registrants should enter. To
-- accomplish this, we use the acs_attribute system, adding attributes 
-- to the events_registration object and keeping a mapping of attribute to 
-- each event/activity.

create table events_event_attr_map (
       event_id			integer
                                constraint evnts_evnt_attr_map_evnt_id_fk 
                                references events_events,
       attribute_id		integer 
                                constraint evnts_evnt_attr_map_attr_id_fk 
                                references acs_attributes,
       constraint event_attr_map_pk
       primary key(event_id, attribute_id)
);

create index evnts_attr_map_event_id_idx on events_event_attr_map (event_id);

create table events_def_actvty_attr_map (
       activity_id		integer
                                constraint evnts_act_attr_map_act_id_fk 
                                references events_activities,
       attribute_id		integer 
                                constraint evnts_act_attr_map_attr_id_fk 
                                references acs_attributes,
       constraint events_activity_attr_map_pk
       primary key(activity_id, attribute_id)
);

create index evnts_act_attr_map_act_id_idx on events_def_actvty_attr_map (activity_id);

create sequence events_attr_cat_seq start 1;
create table events_attr_categories (
       category_id		integer
				constraint events_attr_categories_pk
				primary key,
       category_name		varchar(100)
);

create table events_attr_category_map (
       attribute_id		integer  
                                constraint events_attr_cat_map_attr_id_fk 
                                references acs_attributes,
       category_id		integer
                                constraint events_attr_cat_map_cat_id_fk 
				references events_attr_categories,
       constraint events_attr_category_map_pk
       primary key(attribute_id, category_id)
);

create index evnts_attr_cat_map_attr_id_idx on events_attr_category_map (attribute_id);

insert into events_attr_categories
(category_id, category_name)
values
(nextval('events_attr_cat_seq'), 'Personal');
       
insert into events_attr_categories
(category_id, category_name)
values
(nextval('events_attr_cat_seq'), 'Professional');

insert into events_attr_categories
(category_id, category_name)
values
(nextval('events_attr_cat_seq'), 'Travel\Accomodations');
