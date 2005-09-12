<master>
<property name="title">Activities</property>
<property name="context">@context;noquote@</property>

<ul>
<li><a href="activity-add">Add a New Activity</a></li>
</ul>

<h3>Current Activities</h3>

<ul>
<if @available_activities:rowcount@ gt 0>
<multiple name="available_activities">
 <li><a href="activity?activity_id=@available_activities.activity_id@">@available_activities.name@</a></li>
</multiple>
</if>
<else>
<li>No current activities</li>
</else>
</ul>

<h3>Discontinued Activities</h3>

<ul>
<if @unavailable_activities:rowcount@ gt 0>
<multiple name="unavailable_activities">
 <li><a href="activity?activity_id=@unavailable_activities.activity_id@">@unavailable_activities.name@</a></li>
</multiple>
</if>
<else>
 <li>No discontinued activities</li>
</else>
</ul>

