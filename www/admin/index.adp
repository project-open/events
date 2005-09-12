<master>
<property name="title">Events Administration</property>
<property name="context_bar">@context_bar;noquote@</property>

<ul>
 <li><a href="activities">View/Add/Edit/Manage Activities</a>
 <li><a href="venues">View/Add/Edit Venues</a>
 <li><a href="roles">View/Add/Edit Roles</a>
 <p>
   <li><a href="@parameters_edit_url@">Edit parameters</a></li>
 </p>
</ul>
<p>
<em>(Note: To add/edit an event, you must first go to the 
<a href="activities">activities</a> page to select the type of
activity for your event.  Then, you may add/edit an event
based upon that activity.)
</em>

<h3>Current Events Registration Status</h3>

<if @available_events_and_locations:rowcount@ eq 0>
	<ul>
	  <li>There are no current events to display
	</ul>
</if>

<else>
  <table>
	<tr><th>Activity</th><th>Location</th><th>Date</th></tr>
    <multiple name=available_events_and_locations>
	<tr>
           <td><a href="event?event_id=@available_events_and_locations.event_id@">
		@available_events_and_locations.name@</a></td>
	   <td>@available_events_and_locations.city@</td>
	   <td>@available_events_and_locations.timespan@</td>
	</tr>
    </multiple>
  </table>
</else>

</p> 
