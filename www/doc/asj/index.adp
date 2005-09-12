<master>
<property name="title">Web-Based Event Planning and Registration</property>
<property name="context">"<a href=/doc/events>Events Documentation</a> : ASJ Article"</property>
<h2>
ArsDigita Systems Journal: Web-Based Event Planning and Registration
</h2>
 by  Bryan Che

<p><font size="-1">Sumbitted on: 2000-06-09
<br>Last updated: 2000-09-25</font>

<p>
Online registration harnesses much of the Internet's power.  It saves
time, enhances productivity, and simplifies operations.  It lowers
costs.  It facilitates community.  It provides flexibility.
Surprisingly, though, online registration provides these benefits more
to event administrators than to the people who register for events.
<p>

Web-based registration does provide some measure of ease for event
attendees.  In addition to eliminating paper forms, Web-based
registration can facilitate collaboration among registrants.
It can also provide immediate feedback to people when they register.
For event planners, though, online registration offers the ability to:

<ul>
<li>	Make it easy to offer repeated events
<li>	Make it easy to collect, aggregate, and view registrations
<li>	Provide convenient means for communicating with registrants
<li>	Provide means for coordinating registrants
</ul>

These four advantages can save event administrators a tremendous amount
of work and time.  Thus, even though event participants may gain from
Web-based event registration, event administrators are the ones who
truly profit from it.

<h3>Events Module Goals Overview</h3>
The events module has four main goals. In accordance with the fact that
online events handling benefits event planners the most, these goals
focus on helping event administrators. The events module aims to:

<ul>
<li>	Simplify offering repeat events
<li>	Simplify handling registrations
<li>	Simplify communicating with registrants
<li>	Simplify coordinating registrants
</ul>


<h4>Repeated Events</h4>

Organizations often offer the same basic event on a repeated basis. For
example, ArsDigita runs a series of bootcamps each month. These
bootcamps are essentially the same -- they teach the same material,
last the same amount of time, and provide similar experiences. The only
things that really vary are where and when these bootcamps occur.
Therefore, data within the events module divides into <i>activities</i>
and <i>events</i>.
<p>

An activity is a kind of event; it is the type of thing for which people
register. Activities might be bootcamps or lectures or conferences. An
event is an instance of an activity. An event might be a three-week
bootcamp starting on June 28, 2000 in Cambridge, MA or an Oracle
conference in Amsterdam from July 23-25, 2001.
<p>

By making this distinction between activities and events, the events
module can help event planners avoid repeated work. For example, people
who want to manage ArsDigita bootcamps need only perform all of their
major planning once. They can plan what their bootcamp activity will
cover, what type of information registrants need to provide, and so on
the first time they plan a bootcamp. From then on, whenever they want
to create an online registration form for a new bootcamp, they do not
need to repeat entering information that is the same across all
bootcamps. Instead, they may simply edit items specific to a particular
bootcamp event -- where and when that bootcamp takes place, for
example. The events module will then generate an appropriate
registration form for users based upon the bootcamp's activity
information and its specific event information. This process makes it
quite convenient to offer events on a repeated basis.
<p>

<a href="order-history-one-activity.html">[screenshot of order histories for different events of a particular activity]</a>

<h4>Handling Registrations</h4>

Filling out a registration form by hand may not
be terribly inconvenient. But, processing thousands of hand-written
registration forms is. Therefore, offering online, electronic
registration forms can save event administrators significant time.
Online registration forms means that as soon as a registrant submits his
application, event administrators may review the registration online
without much hassle. Furthermore, they can easily view aggregate
information, such as how many people have registered for a particular
event. And, they may approve, deny, or mark registrations using simple
point-and-click interfaces. Managing registrations online can save
event planners a significant amount of work. 
<p>

<a href="reg-wait-list.html">[screenshot of admin page for wait-listing a registration]</a>

<h4>Communicating with Registrants</h4>

Another benefit of online registration is that it can facilitate easy
communication between event planners and registrants. The events module
collects e-mail addresses from each person who registers for a certain
event. Thus, it can provide an interface for helping event planners do
things like "e-mail all the people who attended these three conferences"
or "e-mail this particular registrant to request more information about
his work history." Because all registration, event, and communication
information is provided through the same user interface (the Web),
communicating with various event registrants is a simple task. Thus,
online registration can greatly help event designers to communicate with
registrants.
<p>

<a href="spam-selected-events.html">[screenshot of page for e-mailing registrants]</a>

<h4>Coordinating Registrants</h4>

Because registrants have entered some personal information online when
registering for an event, the events module can help event
administrators organize these registrants into user groups. These
groups of users can then interact with bulletin boards, calendars, and
other features which the event administrator sees fit to add. In this
way, event administrators can easily provide a variety of
community-fostering features for people who register online. If these
people had not registered online and were not entered into a database,
then they would not be able to socialize, communicate, and work together
over the Internet as members of the same event.
<p>

<a href="chat.html">[screenshot of entrance to ACS chat rooms]</a>

<h3>Events Module Implementation</h3>

<h4>The Data Model</h4>

The events module's data model consists of four main sections: 

<ul>
<li>tables for managing the events
<li>tables for collecting custom fields
<li>tables for managing events organizers
<li>tables for managing events registrants
</ul>

<p>
<center>
<img src="entity-relationship.gif">
</center>
<p>

<h5>Managing Events</h5>

<h6>Activities</h6>

An organization is not necessarily an entire company -- it can be a
company department or office or project or any other group of
people. Therefore, activities are owned by ACS user groups. Each user
group represents an organization of people. An activity also has a
creator, a name, a description, and a flag indicating if it is
available. Finally, an activity can link to a url for more information: 
<p>

<blockquote>
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
        detail_url 	varchar(256), -- URL for more details
	default_contact_user_id integer references users
);
</pre>
</blockquote>
<p>

<h6>Events</h6>

Information about the events are stored in the tables events_events,
events_prices, and events_venues. events_events tracks data such as an
event's start and end times, where it occurs, and how many people may
register for it.
<p>

<blockquote>
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
</pre>
</blockquote>
<p>

This data model contains, through events_prices, extensions for selling
admission to events. The presentation pages, however, do not currently
implement this feature. These extensions can tie in with the ecommerce
module. 


<blockquote>
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
</blockquote>
<p>

The table events_venues retains knowledge about all the different
locations in which an event might take place.


<h5>Collecting Custom Fields</h5>

One of the hallmark features of the events module is its ability to let
event administrators collect customized information from events
registrants. Organizations are usually interested in obtaining more
than just a name and e-mail address. For example, a company might
request registrants to provide their resumes. The company could do this
in the events module by creating a custom field for its event called
<i>resume</i>. 

<p>

<blockquote>
<pre>
create table events_event_fields (
	event_id	not null references events_events,
	column_name	varchar(30) not null,
	pretty_name	varchar(50) not null,
	-- something generic and suitable for handing to AOLserver, 
	-- e.g., boolean or text
	column_type	varchar(50) not null,
	-- something nitty gritty and Oracle-specific, e.g.,
	-- char(1) instead of boolean
	-- things like "not null"
	column_actual_type	varchar(100) not null,
	column_extra	varchar(100),
	-- Sort key for display of columns.
	sort_key	integer not null
);
</pre>
</blockquote>
<p>

<h5>Managing Organizers</h5>

Each event should have at least one organizer role. An organizer role is
an official position for that event. For example, a lecture might have
the organizer role of "speaker." Organizers are people who fill an
organizer role position.
<p>

<blockquote>
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
</blockquote>
<p>

<h5>Managing Registrations</h5>

For each person who registers for an event, the software helps
organizations understand who is coming to their events and why. It also
helps an organization accommodate its attendees' needs and group them
together. 
<p>

The events module organizes registrations in the following way: a
registration represents a person who has expressed interest in attending
the event. There is one registration for each person who wants to
attend. Registrations can have different states. For example, a
registration may be wait-listed because there are already too many
registrations for a particular event. Or, a registration may be
canceled.
<p>

An order is a set of registrations. Typically, when a person registers
himself for an event, he will create one order containing his single
registration. But, there may be an individual who wishes to register
multiple people at once. In that case, the individual would make one
order containing multiple registrations. Thus, this data model allows
people to make multiple registrations. The Web pages do not yet
implement this feature, though.
<p>

<blockquote>
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
</blockquote>
<p>

<h4>The Presentation Pages</h4>

The vast majority of the events module's Web interface is located in its
admin directory. From these pages, an event administrator can manage
his events and event registrants. 

<h5>The Main Admin Page</h5>

The main administration page provides a summary of current event
registrations and links to the key functions he can perform:
<ul>
<li>Managing activities
<li>Managing venues
<li>Viewing order histories
<li>Spamming (e-mailing) registrants
</ul>
<p>

<a href="main-admin.html">[screenshot of main admin page]</a>
<p>

<h5>Managing Activities and Events</h5>

As previously stated, one of the goals of the events module was to
facilitate repeating events through the use of activities and events.
Separate admin pages for managing activities and events accomplish this
goal. Furthermore, the event admin page links to pages which fulfill
other goals for the events module: The event admin page links to pages
displaying order-histories, helping administrators handle registrations.
It also links to pages for e-mailing registrants, providing for easy
communication to registrants. Finally, it links to the event's user
group, letting the administrator coordinate registrants.
<p>

<a href="activity-admin.html">[screenshot of activity admin page]</a>
<p>

<a href="event-admin.html">[screenshot of event admin page]</a>
<p>

One of the links from the main administration page is for managing
venues. Venues are locations where events occur. Since an organization
or person's events will usually take place within a certain set of
venues, the events module provides a means of creating and managing
these locations. Then, when an event administrator creates an event, he
can easily select an existing venue for his event -- and save himself the
work of typing in all the relevant information for that venue again.
<p>

<a href="venues-admin.html">[screenshot of venues admin page]</a>
<p>

<h5>Managing Registrations</h5>

The Order History pages provide most of the functionality for managing
registrations. From these pages, event administrators can view
aggregated registration information and answer questions such as, "how
many people registered for that event," or "how many people placed
registrations on this date?"
<p>

<a href="order-history.html">[screenshot of order history index page]</a>
<p>

Event administrators can also view a single registration and perform
actions upon it, like approving it.
<p>

<a href="single-order-history.html">[screenshot of single registration order history]</a>
<p>


<h5>E-mailing Registrants</h5>

When a person places a registration in the events module, he has to
provide his e-mail address. This means that event administrators can
e-mail groups of registrants and individual registrants from the admin
pages -- perhaps, for example, to advertise an upcoming, similar event.
<p>

<a href="spam.html">[screenshot of page for e-mailing registrants]</a>
<p>

<h5>Coordinating Registrants</h5>

Because the events module is part of the ArsDigita Community System
(ACS), it has access to all of the community-building features within
the ACS. Each event, as explained earlier, has a corresponding ACS user
group. All registrants for a particular event are automatically placed
into their respective event's user group. This means that event
administrators can easily provide, using other ACS modules, the ability
for an event's registrants to communicate and collaborate together in a
variety of ways. For example, the event administrator could add a
bboard to an event's user group. Then, the individuals within that user
group could post messages for each other. The link to managing the
event's user group comes from the event admin page. 
<p>

<a href="bboard.html">[screenshot of an ACS bulletin board]</a>
<p>

<h5>User Registration</h5>

Although the power and convenience of online registration benefits
events administrators the most, registrants should still find it simple
to register for an event. Thus, the user interface for placing a
registration is fairly straightforward. The events module tries to fill
in as much personal information as possible for the registrant if he is
already an ACS user of the registration Web site. Then, the user must
simply provide the rest of the registration material in which the even
planners are interested.
<p>

<a href="order-one.html">[screenshot of registration page]</a>
<p>

<h3>Events Module Comparison</h3>

<h4>Key3Media</h4>

Because the events module focuses on enabling event administrators
rather than event registrants, it offers significant advantages against
most online registration offerings, which traditionally view Web-based
registration as simply another way to collect registration information.
Registration sites which do not offer special capabilities for event
planners lose out on much of the power and efficiency that comes from
offering events online. For example, Key3Media is a large company which
handles online registration for a number of events, including Comdex,
JavaOne, and Linux Business Expo. But, Key3Media treats online
registration as nothing more than another means to collect information
as part of a complicated setup for registering people.
<p>

Key3Media collects registration information for events through both
paper and Web applications. Web applications go directly into a
database; paper applications are entered into the database by Key3Media
employees. Once Key3Media processes an application, it sends a
confirmation message to the application's registrant. Online
registrants receive an online confirmation, and paper applicants receive
a paper confirmation.
<p>

Upon completing signups for an event, Key3Media exports all of its
registration information into a file -- typically a Microsoft Excel
spreadsheet -- and gives the file to another company. This company
serves as a "holding tank" for the registration data and eventually
passes the records to a third company. This third company may be the
Key3Media client running the event or perhaps a company building a Web
site for the client's event, and it uses the registration data as it
wishes.
<p>

Key3Media's solution for handling event registration seems to work fine
for collecting information. But, its solution does little to help event
planners communicate with registrants, coordinate registrants, and
aggregate information about registrants. Key3Media cannot inform a
client for what other of the client's events a person has registered.
Key3Media cannot help registrants collaborate and communicate.
Key3Media cannot offer a centralized, unified, and integrated interface
to event management. The events module, by focusing on event planners,
does offer all these features in addition to facilitating easy online
event-registration.
<p>

<%
#UNCOMMENT THIS SECTION OUT ONCE WE HAVE APPROVAL
#FROM ORACLE TO PUBLISH IT

#One significant reason for choosing Key3Media is that it will process both
#paper and electronic registrations. Because the events module is a
#Web-based application, it cannot intrinsically handle paper
#applications. However, event administrators may still take advantage of
#the planning and organizing capabilities of the events module while
#contracting out registration-handling to a company like Key3Media.
#Indeed, this is what Oracle is doing for its iDevelop 2000 Conferences
#site (<a href="http://idevelop2000.com">http://idevelop2000.com</a>).
#<p>
#
#ArsDigita is building the Oracle iDevelop site based upon the events
#module. By doing so, ArsDigita enables Oracle iDevelop planners to
#manage their conferences and conference attendants. But, Oracle has
#hired another company (Key3Media) to handle its registrations, allowing
#Oracle to offer multiple means of registration. Once Key3Media has
#collected its registration data, it will pass the information to
#ArsDigita. ArsDigita will then upload the registration information into
#the events module -- allowing iDevelop administrators to organize their
#conferences and attendees just as if the attendees had registered for
#iDevelop through the events module's own registration pages. In this
#way, Oracle will be able to harness virtually all of the power of the
#events module while still allowing for paper-based registrations. Of
#course, why anyone attending an Oracle Technology Network conference
#would choose a paper application over the Internet is another matter.
%>

<h4>Evite.com</h4>

Although most Web sites that offer online registration do not support
much functionality for event planners, there are a number of sites
springing up which offer users some basic abilities to plan and organize
personal functions. Evite.com 
(<a href="http://www.evite.com">http://www.evite.com</a>) is one such
popular site.
<p>

Evite.com focuses on helping users to plan events for which they would
like to invite guests. It does this by offering a simple interface for
individuals to:

<ul>
<li>plan a series of events
<li>invite people to those events
<li>RSVP to events to which they are invited
<li>see who is coming to their events
<li>remind themselves about events
</ul>

In many ways, Evite.com and other, similar sites
(<a href="http://socialeventplanner.com">http://socialeventplanner.com</a>, 
<a href="http://invites.yahoo.com">http://invites.yahoo.com</a>,
<a href="http://www.pleasersvp.com">http://www.pleasersvp.com</a>, 
and so on) understand that their sites are
useful because they enable people to plan and organize events. Evite
even supports, to some extent, the four goals outlined for the events
module.
<p>

Evite supports repeating events as well as the distinction between
activities and events. For example, a user can create invitations for a
"Birthday" event and have this Birthday event repeat every year.
Birthdays, then, are like activities in the events module, and the
annual Birthday parties are like events within the events module.
Evite.com, though, does not support creating arbitrary activities like
the events module.
<p>

Evite helps users handle registrations by allowing users to setup lists
of guests to invite to their events. Once a user has setup a guest list
for an event, Evite sends e-mail to each person on the user's guest
list, notifying him that he has been invited to an event. Evite also
allows these invitees to RSVP so that users may see who is coming to
their events. Evite lacks, however, a number of the aggregation and
advanced registration-handling functions of the events module. Evite
also does not let users create events for which arbitrary users can
register -- event registrants must first be invited.
<p>

Communicating with invitees through Evite takes place through Evite's
address book features. Users may store email contacts and create groups
of contacts within their address book. Then, they can send e-mail to
individual e-mail addresses or to groups of e-mail addresses. This
functionality seems fairly limited as it does not provide much support
for communicating within the context of an event. For example, users
cannot ask to e-mail "all the people who attended these three
events" -- as they could within the events module.
<p>

If Evite offers limited communications capabilities, it supports even
fewer community-building options. Unlike the events module, which
supports a host of community capabilities through other ACS modules,
Evite merely lets invitees see who else is coming to a particular event.
<p>

Evite.com and other event planning sites on the Internet are optimized
to help individuals plan social events like a Memorial Day barbeque.
The events module was designed to handle enterprise event planning and
registration -- and is consequently much more powerful than a site like
Evite.com. People may still use the events module, though, to implement
something like Evite.com; its data model and Web pages intrinsically
support virtually all of the functionality of Evite. 


<h3>Events Module Future Features</h3>

ArsDigita has been using the events module for several months now on its
own Web site 
(<a href="http://www.arsdigita.com/events">http://www.arsdigita.com/events</a>). 
This module has handled thousands of registrations for lectures,
bootcamps, and other activities. So far, the events module has
performed well and provided event administrators with a great deal of
time-saving and convenience. The module more than adequately achieves
the four goals I outlined in the beginning of this article. Still,
there are several key areas in which ArsDigita plans to improve
this module. 
<p>

First of all, the data model for the events module supports
tasks which the Web pages do not yet implement. These main
features are support for various event prices, support for online
payment for events, and support for multiple registrations per order.
Adding these features will enable organizations to charge registrants
for their events, charge different types of registrants different
amounts of money, and allow one person to place multiple registrations
on behalf of other people.
<p>

ArsDigita also plans to expand its support of event registrations for
sub-communities.  The events module already allows ACS user groups to
own event activities.  Consequently, user groups may administrate their
own events and also restrict others from administering those same
events.  But, this is the extent of the event module's sub-community
features.  ArsDigita intends to further aid sub-communities by making it
possible for them to maintain their own "instances" of the events
module.  Thus, sub-sites will be able to offer their own, distinct
registration pages and URL's as well as administration pages.  An
ArsDigita Boot Camp sub-community could, for example, offer its own
events at www.arsdigita.com/bootcamp/events/ instead of listing its boot
camps along with all the other events at www.arsdigita.com/events/.
<p>

Finally, there are some areas in the data model ArsDigita plans to
re-write because they are not elegant. Foremost of these areas is how
the module handles event custom fields. Currently, the data model is
styled after the user group module and creates a new event_n_info table
for each event. Ideally, the module would store custom information
within the user_group_member_fields/user_group_member_field_map tables.
But, these tables do not support enough data types for the events module
yet. There are plans, though, to update these user group tables in the
near future so that the events module may store information within them
for registrants.

<p>
Submitted by  Bryan Che 
