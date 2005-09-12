<master>
<property name="title">@attribute_info.name;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<h3>Events using this field</h3>

<ul>
<if @eam:rowcount@ gt 0>
<multiple name="eam">
 <li><a href="event?event_id=@eam.event_id@">@eam.name@</a> (@eam.pretty_start_date@ - @eam.pretty_end_date@)</li>
</multiple>
</if>
<else>
 <li>No events are currently using this field</li>
</else>
</ul>

<h3>Activities using the field</h3>

<ul>
<if @aam:rowcount@ gt 0>
<multiple name="aam">
 <li><a href="activity?activity_id=@aam.activity_id@">@aam.name@</a></li>
</multiple>
</if>
<else>
 <li>No activities are currently using this field</li>
</else>
</ul>

<h3>Custom Field Description</h3>

<table>
<tr>
  <th valign=top align=right>Name</th>
  <td valign=top>@attribute_info.name@</td>
</tr>
<tr>
  <th valign=top align=right>Pretty Name</th>
  <td valign=top>@attribute_info.pretty_name@</td>
</tr>
<tr>
  <th valign=top align=right>Pretty Plural</th>
  <td valign=top>@attribute_info.pretty_plural@</td>
</tr>
<tr>
  <th valign=top align=right>Data type</th>
  <td valign=top>@attribute_info.datatype@</td>
</tr>
<tr>
  <th valign=top align=right>Category</th>
  <td valign=top>@attribute_info.category_name@</td>
</tr>
<tr>
  <th valign=top align=right><nobr>Sort Order<nobr></th>
  <td valign=top>@attribute_info.sort_order@</td>
</tr>
</table>

<ul>
<li><a href="field-edit?attribute_id=@attribute_id@">Edit Field</a></li>
<if @eam:rowcount@ eq 0><if @aam:rowcount@ eq 0><li><a href="field-delete?attribute_id=@attribute_id@">Delete Field</a></li></if></if>
</ul>

