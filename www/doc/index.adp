<master>
<property name="title">Events Module</property>
<property name="context">"Events Documentation"</property>

<h2>Events</h2>

(part of the <a href="/doc/index">ArsDigita Community System</a>,
originally by <a href="http://photo.net/philg/">Philip Greenspun</a> and Bryan Che)

<p>
<em>Note: this documentation refers to the 3.x version of Events. I plan
to update these soon but even as is, they will give a good overview of the
functionality as well as some possible future directions. The new
version uses ACS Events and many of the new 4.x modules including bulk
mail and attachments. Bryan Che also wrote an ASJ article on Events,
which I've included at <a
href="/doc/events/asj">/doc/events/asj</a>.</em>   
</p>

<ul>
<li>User-accessible directory:  <a href="/events/">/events/</a> (or wherever you've mounted events)
<li>Administrator directory:  <a href="/events/admin/">/events/admin/</a>
<li>data model and Tcl procs:  <a href="/api-doc">/api-doc</a>
</ul>

<h3>The Big Idea</h3>

<p>
Organizations often present events, such as a lecture series or a social
gathering.  This software module gives organizations a way to register
people for events online.


<h3>The Medium-sized Idea</h3>

<p>
Organizations often have a number of set events which they like to
repeat.  For example, a company may have a certain presentation which it
makes over and over.  A photoraphy club may hold monthly outings.  A
marathon race could occur annually.  Therefore, we organize events in
the following way:

<p>
Each organization has a series of <i>activities</i> that it holds.  An
<i>event</i> is a particular instance of an activity--it is the actual
occurance of an activity.  Each event has an organizer and takes place
in a physical location and during a certain time.  For example, a
software company might hold a series of talks as activities:
<table cellpadding=5>
<tr align=left><th>Company Talks</th></table>
<ul>
 <li>Why you should think our software is the best
 <li>Why you should do things our way
 <li>Why the Government should leave us alone and let us innovate
</ul>
<p>
That software company could then present these talks as lecture events:
<p>
<table cellpadding=5>
<tr align=left>
 <th>Talk (Activity)
 <th>Lecture Speaker (Event organizer)
 <th>Lecture Date
<tr align=left>
 <td>Why you should think our software is the best
 <td>billy
 <td>05-07-2000
<tr align=left>
 <td>Why you should think our software is the best
 <td>stevie
 <td>08-29-2000
<tr align=left>
 <td>Why the Government should leave us alone and let us innovate
 <td>billy
 <td>09-10-2000
</table>

<p>
Organizations that organize their events using this convention may
then fully administer and register those events online using this
module.  

<h3>The Fine-details</h3>

<h4>Activities</h4>

<p>
An organization is not necessarily an entire company--it can be a
company department or office or project or any other group of people.
Therefore, activities are owned by ACS user groups.  Each user group
represents an organization of people.  An activity also has a creator, a
name, a description, and a flag indicating if it is available.  Finally,
an activity can link to a url for more information:

<pre>
create table events_activities (
	activity_id	integer primary key,
	-- activities are owned by user groups
	group_id	integer references user_groups,
        creator_id      integer not null references users,
	short_name	varchar(100) not null,
	default_price   number default 0 not null,
	currency	char(3) default 'USD',
	description	clob,
        -- Is this activity occurring? If not, we can't assign
        -- any new events to it.
        available_p	char(1) default 't' check (available_p in ('t', 'f')),
        deleted_p	char(1) default 'f' check (deleted_p in ('t', 'f')),
        detail_url 	varchar(256) -- URL for more details,
	default_contact_user_id integer references users
);
</pre>

<h4>Events</h4>
<p>
For each event, we need to track its organizers, its location, and its
time.  We define the organizers' roles and their responsibilities.  We
also store extra information that might pertain to that specific event,
such as refreshemnts or audio/visual information.  In addition, we store
of which activity this event is an instance.

<pre>
create table events_events (
        event_id              integer not null primary key,
        activity_id	      integer not null references events_activities,
	venue_id	      integer not null references events_venues,
	-- the user group that is created for this event's registrants
	group_id	      integer not null references user_groups,
	creator_id	      integer not null references users,
        -- HTML to be displayed after a successful order.
        display_after         varchar(4000),
        -- Date and time.
        start_time            date not null,
        end_time              date not null,
	reg_deadline	      date not null,
        -- An event may have been cancelled.
        available_p	      char(1) default 't' check (available_p in ('t', 'f')),	
        deleted_p	      char(1) default 'f' check (deleted_p in ('t', 'f')),
        max_people	      integer,
	-- can someone cancel his registration?		
	reg_cancellable_p     char(1) default 't' check (reg_cancellable_p in ('t', 'f')),
	-- does a registration need approval to become finalized?
	reg_needs_approval_p  char(1) default 'f' check (reg_needs_approval_p in ('t', 'f')),
	-- notes for doing av setup
	av_note		      clob,
	-- notes for catering
	refreshments_note     clob,
	-- extra info about this event
	additional_note	      clob,
	-- besides the web, is there another way to register?
	alternative_reg	      clob,
        check (start_time < end_time),
	check (reg_deadline <= start_time)
);


-- where the events occur
create table events_venues (
       venue_id		  integer primary key,
       venue_name	  varchar(200) not null,
       address1		  varchar(100),
       address2		  varchar(100),
       city		  varchar(100) not null,
       usps_abbrev	  char(2),
       postal_code	  varchar(20),
       iso		  char(2) default 'us' references country_codes,
       time_zone	  varchar(50),
       -- some contact info for this venue
       fax_number	  varchar(30),
       phone_number	  varchar(30),
       email		  varchar(100),
       needs_reserve_p	  char(1) default 'f' check (needs_reserve_p in ('t', 'f')),
       max_people	  integer,	
       description	  clob
);

</pre>

<p>
This data model also contains extensions for selling admission to
events, althought the tcl pages do not currently implement this feature.
These extensions can tie in with the 
<a href="/doc/ecommerce">ecommerce module</a>.  

<pre>
create table events_prices (
    price_id            integer primary key,
    event_id            integer not null references events_events,
    -- e.g., "Developer", "Student"
    description         varchar(100) not null,
    -- we also store the price here too in case someone doesn't want
    -- to use the ecommerce module but still wants to have prices
    price		number not null,
    -- This is for hooking up to ecommerce.	
    -- Each product is a different price for this event.  For example,
    -- student price and normal price products for an event.
--  product_id          integer references ec_products,
    -- prices may be different for early, normal, late, on-site
    -- admission,
    -- depending on the date
    expire_date	      date not null,
    available_date    date not null
);

</pre>

<p>


<h4>Organizers</h4> 

Each event should have at least one organizer role.  An organizer role
is an official position for that event.  For example, a lecture
might have the organizer role of "speaker."  Organizers are people
who fill an organizer role position.


<pre>
create table events_event_organizer_roles (
       role_id			integer 
				constraint evnt_ev_org_roles_role_id_pk 
				primary key,
       event_id			integer 
				constraint evnt_ev_org_roles_event_id_fk 
				references events_events
				constraint evnt_ev_org_roles_event_id_nn
				not null,  
       role			varchar(200) 
				constraint evnt_ev_org_roles_role_nn
				not null,
       responsibilities		clob,
       -- is this a role that we want event registrants to see?
       public_role_p		char(1) default 'f' 
				constraint evnt_ev_roles_public_role_p
				check (public_role_p in ('t', 'f'))
);

create table events_organizers_map (
       user_id			   constraint evnt_org_map_user_id_nn
				   not null
				   constraint evnt_org_map_user_id_fk
				   references users,
       role_id			   integer 
				   constraint evnt_org_map_role_id_nn
				   not null 
				   constraint evnt_org_map_role_id_fk
				   references events_event_organizer_roles,
       constraint events_org_map_pk primary key (user_id, role_id)
);

</pre>

<h4>Registrations</h4>
For each person who registers for an event, we record a bunch of
information.  This helps the organizations understand who is coming to
their events and why.  It also helps the organization accomodate its
attendees' needs and group them together.

<p>
We organize registrations in the following way: a <i>registration</i>
represents a person who has expressed interest in attending the event.
There is one registration for each person who wants to attend.
Registrations can have different states.  For example, a registration
may be wait-listed because there are already too many registrations for
a particular event.  Or, a registration may be canceled.
<p>
An <i>order</i> is a set of registrations.  Typically, when a person
registers himself for an event, he will create one order containing his
single registration.  But, there may be an individual who wishes to
register multiple people at once.  In that case, the individual would
make one order containing multiple registrations.  Thus, this data
model allows people to make multiple registrations.  The tcl pages do
not yet implement this feature, though.

<pre>
create table events_orders (
       order_id		integer not null primary key,
--       ec_order_id	integer references ec_orders,
       -- the person who made the order
       user_id		integer not null references users,
       paid_p		char(1) default null check (paid_p in ('t', 'f', null)),
	payment_method	varchar(50),
	confirmed_date	date,
	price_charged	number,
	-- the date this registration was refunded, if it was refunded
	refunded_date	date,
	price_refunded	number,	
       	ip_address	varchar(50) not null
);

create table events_registrations(
        -- Goes into table at confirmation time:
	reg_id		integer not null primary key,
	order_id	integer not null references events_orders,
	price_id	integer not null references events_prices,
	-- the person registered for this reg_id (may not be the person
	-- who made the order)
	user_id		integer not null references users,
	-- reg_states: pending, shipped, canceled, waiting
	--pending: waiting for approval
	--shipped: registration all set 
	--canceled: registration canceled
	--waiting: registration is wait-listed
	reg_state	varchar(50) not null check (reg_state in ('pending', 'shipped', 'canceled',  'waiting')),
	-- when the registration was made
	reg_date	date,
	-- when the registration was shipped
	shipped_date	date,
	org		varchar(4000),
	title_at_org	varchar(4000),
	attending_reason  clob,
	where_heard	varchar(4000),
	-- does this person need a hotel?
        need_hotel_p	char(1) default 'f' check (need_hotel_p in ('t', 'f')),
	-- does this person need a rental car?
        need_car_p	char(1) default 'f' check (need_car_p in ('t', 'f')),
	-- does this person need airfare?
	need_plane_p	char(1) default 'f' check (need_plane_p in ('t', 'f')),
	comments	clob
);

</pre>

<h3>Using Events</h3> 

<p>
With the events module, organizations can create, edit, and remove
activities.  They can do the same to events and organizers.  Thus,
organizations can fully describe and advertise any activity event
online.

<p>
Organizations can also obtain information about who is coming to their
events and spam those attendees.  They can review order histories to see
how many people registered for a given event and why they came.  In
addition, they can view order statistics by activity, month, date, and
order state.  Finally, they can spam their own organizers to remind them
about their upcoming events.

<p>
People coming to register online at a site using this module will be
able to find upcoming activity events and sign up for them.

