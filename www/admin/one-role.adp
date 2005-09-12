<master>
<property name="title">@role_info.role;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<h3>Event associations</h3>

<ul>
<if @erm:rowcount@ gt 0>
<multiple name="erm">
 <li><a href="event?event_id=@erm.event_id@">@erm.name@</a> (@erm.pretty_start_date@ - @erm.pretty_end_date@)</li>
</multiple>
</if>
<else>
 <li>No event mappings for this role</li>
</else>
</ul>

<h3>Activity associations</h3>

<ul>
<if @arm:rowcount@ gt 0>
<multiple name="arm">
 <li><a href="activity?activity_id=@arm.activity_id@">@arm.name@</a></li>
</multiple>
</if>
<else>
 <li>No activity mappings for this role</li>
</else>
</ul>

<h3>Role Description</h3>

<table>
<tr>
  <th valign=top align=right>Role Name</th>
  <td valign=top>@role_info.role@</td>
</tr>
<tr>
  <th valign=top align=right>Responsibilities</th>
  <td valign=top>@role_info.responsibilities@</td>
</tr>
<tr>
  <th valign=top align=right><nobr>Public Role?<nobr></th>
  <td valign=top><if @role_info.public_role_p@>Yes</if><else>No</else></td>
</tr>
</table>

<ul>
<li><a href="role-edit?role_id=@role_id@">Edit Role</a></li>
<if @erm:rowcount@ eq 0><if @arm:rowcount@ eq 0><li><a href="role-delete?role_id=@role_id@">Delete Role</a></li></if></if>
</ul>

