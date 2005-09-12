<master>
<property name="title">@activity_info.name;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>Events for this Activity</h3>

<ul>

@events;noquote@

  <p></p>
  <if @activity_info.available_p@>
      <li><a href="event-add?activity_id=@activity_id@">Add an Event</a>
  </if>
</ul>

<h3>Activity Description</h3>

<table>
  <tr>
    <th valign=top align=right>Name</th>
    <td valign=top>@activity_info.name@</td>
  </tr>
  <tr>
    <th valign=top align=right>Creator</th>
    <td valign=top>@creator_info.name@</td>
  </tr>
  <tr>
    <th valign=top align=right><nobr>Default Contact Person<nobr></th>
    <td valign=top><a href="mailto:@activity_info.default_contact_email@">@activity_info.default_contact_email@</a></td>
  </tr>
  <tr>
   <th valign=top align=right>URL</th>
   <td valign=top><a href="@activity_info.detail_url@">@activity_info.detail_url@</a></td>
  <tr>
    <th valign=top align=right>Description</th>
    <td valign=top>@activity_info.description@</td>
  </tr>
  <tr>
    <th valign=top align=right><nobr>Current or Discontinued<nobr></th>
      <if @activity_info.available_p@>
        <td valign=top>Current</td>
      </if>
      <else>
        <td valign=top>Discontinued</td>
      </else>
  </tr>
</table>

<p>
<ul>
  <li><a href="activity-edit?activity_id=@activity_id@">Edit Activity</a>
</ul>

<h3>Organizer Roles</h3>
You may create default organizer roles for this activity type.
<ul>
  <if @org_roles:rowcount@ gt 0>
  <multiple name="org_roles">
  	<li>@org_roles.role@ @org_roles.public_role_p@  <font size="-1" face="arial"> &nbsp;&nbsp;
  	[ <a href="role-remove?role_id=@org_roles.role_id@&activity_id=@activity_id@">remove</a> ]
  	</font></li>
  </multiple>
  </if>
  <else>
    <li>There are no organizer roles for this activity</li>
  </else>
<p></p>
  <li><a href="role-add?activity_id=@activity_id@">Add an organizer role</a>
</ul>

<h3>Event Statistics</h3>
        <table border=1 cellpadding=3 cellspacing=0>
            <tr>
                <td align="center"><a href="activity-orders?activity_id=@activity_id@&specific_reg_type=approved"><font color="green">Approved</font></a></td>
                <td align="center"><a href="activity-orders?activity_id=@activity_id@&specific_reg_type=pending"><font color="red">Pending</font></a></td>
                <td align="center"><a href="activity-orders?activity_id=@activity_id@&specific_reg_type=waiting"><font color="blue">Waiting</font></a></td>
                <td align="center"><a href="activity-orders?activity_id=@activity_id@&specific_reg_type=canceled"><font color="gray">Canceled</font></a></td>
            </tr>  
            <tr>
                <td align="center"><font color="green">@activity_stats.approved@</a></td>
                <td align="center"><font color="red">@activity_stats.pending@</a></td>
                <td align="center"><font color="blue">@activity_stats.waiting@</a></td>
                <td align="center"><font color="gray">@activity_stats.canceled@</a></td>
            </tr>
        </table>
<ul>
  <li><a href="activity-orders?activity_id=@activity_id@">View All Orders for this Activity</a>
  <li><a href="send-mail?activity_id=@activity_id@">Email this activity's registrants</a>
</ul>







