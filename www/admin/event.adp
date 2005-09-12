<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<div align=right>
  <a href="/permissions/one?object_id=@event_id@" class="button">Manage Permissions</a>
</div>


<ul>
<if @event_stats.total_interested@ gt 0> 
    <if @event_stats.total_interested@ eq 1> 
        <li><a href="event-orders?event_id=@event_id@">View the order for this event</a>
    </if>
    <else>
        <li><a href="event-orders?event_id=@event_id@">View the orders for this event</a>
    </else>
</if>
<else>
<li>There have been no orders for this event
</else>


<li><a href="../event-info?event_id=@event_id@">View the page that users see</a></li>
<li><a href="send-mail?event_id=@event_id@&group=registrants">Email this event's registrants</a></li>
</ul>


<table cellpadding=3>
<tr>
  <th valign=top align=right>Creator</th>
  <td valign=top>@creator_name@</td>
<tr>
  <th valign=top align=right>Location</th>
  <td valign=top>@pretty_location@</td>
</tr>
<tr>
  <th valign=top align=right>Confirmation Message</th>
  <td valign=top>@event_info.display_after@</td>
</tr>
<tr>
  <th valign=top align=right>Time</th>
  <td valign=top>@event_info.timespan@</td>
</tr>
<tr>
  <th valign=top align=right>Registration Deadline</th>
  <td valign=top>@event_info.reg_deadline@</td>
</tr>
<tr>
 <th valign=top align=right>Event Statistics</th>
 <td valign=top>






        <table border=1 cellspacing=0 cellpadding=3>
            <tr>
                <td align="center">Max Allowed</td>
		<td align="center">Spots Remaining</td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=approved"><font color="green">Approved</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=pending"><font color="red">Pending</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=waiting"><font color="blue">Waiting</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=canceled"><font color="gray">Canceled</font></a></td>
            </tr>  
            <tr>
                <td align="center"><if @event_stats.max_people@ eq "">N/A</if><else>@event_stats.max_people@</else></td>
                <td align="center"><if @event_stats.max_people@ eq "">N/A</if><else>@count_spotsremaining@</else></td>
                <td align="center"><font color="green">@event_stats.approved@</a></td>
                <td align="center"><font color="red">@event_stats.pending@</a></td>
                <td align="center"><font color="blue">@event_stats.waiting@</a></td>
                <td align="center"><font color="gray">@event_stats.canceled@</a></td>
            </tr>
        </table>




</td>
</tr>
<tr>
 <th valign=top align=right>Registration Cancellable?</th>
 <td valign=top>@event_info.pretty_reg_cancellable_p@</td>
</tr>
<tr>
 <th valign=top align=right>Registration Needs Approval?</th>
 <td valign=top>@event_info.pretty_reg_needs_approval_p@</td>
</tr>
<tr>
 <th valign=top align=right>Event Contact Person</th>
 <td valign=top><a href="mailto:@event_info.contact_email@">@event_info.contact_email@</a></td>
</tr>
<tr>
  <th valign=top align=right>Availability Status</th>
<if @event_info.available_p@ eq "t">
  <td valign=top>Current
  &nbsp; (<a href="event-toggle-available-p?event_id=@event_id@">toggle</a>)
</if>
<else>
  <td valign=top>Discontinued
  &nbsp; (<a href="event-toggle-available-p?event_id=@event_id@">toggle</a>)
  <if @event_stats.total_interested@ gt 0>
  &nbsp;
  <br><font color=red>You may want to 
  <a href="send-mail?event_id=@event_id@&group=registrants">email the registrants for this event</a>
  to notify them the event is canceled.</font>
  </if>
</else>

</td>
</tr>
</table>

<ul>
 <li><a href="event-edit?event_id=@event_id@">Edit Event Properties</a></li>
</ul>

<h3>Organizers</h3>
<ul>
<if @org_roles:rowcount@ gt 0>
 <multiple name="org_roles">
  <li><a href="organizer-edit?role_id=@org_roles.role_id@&event_id=@org_roles.event_id@&activity_id=@event_info.activity_id@">@org_roles.role@:</a> @org_roles.organizer_name@ @org_roles.public_role_p@ <font size="-1" face="arial"> &nbsp;&nbsp;
	[ <a href="role-remove?role_id=@org_roles.role_id@&event_id=@event_id@">remove</a> ]
	</font></li>
</multiple>
</if>
<else>
 <li>There are no organizer roles for this event</li>
</else>
<p></p>
<li><a href="role-add?activity_id=@event_info.activity_id@&event_id=@event_id@">Add an organizer role</a></li>
<if @event_organizers@ gt 0>
 <li><a href="send-mail?event_id=@event_id@&group=organizers">Email all of the organizers for this event</a></li>
</if>
</ul>
</ul>

<if @attachments_enabled_p@>
<h3>Agenda Files</h3>
<ul>
<% 
    foreach attachment $attachments {
        template::adp_puts "<li><a href=\"[lindex $attachment 2]\">[lindex $attachment 1]</a></li>"
    }
%>
</ul>
<ul>
<li><a href="@attachment_link@">Upload an agenda/attachment</a></li>
</ul>
</if>

<h3>Event Notes</h3>
<formtemplate id="event_notes"></formtemplate>
