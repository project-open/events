<master>
<property name="title">Upcoming Events for @activity_info.name;noquote@</property>
<property name="context">@context;noquote@</property>


<if @admin_p@ ne 0>
        <p style="text-align: right;">[<a href="admin/activity?activity_id=@activity_id@">Administer This Activity</a>]</p>
</if>

<h3><u>@activity_info.name@</u> Info:</h3>

@activity_info.description@

<if @upcoming_events:rowcount@ gt 0>
<h3>Upcoming Events for This Activity</h3>
<ul>
<multiple name="upcoming_events">
<li><a href="order-one?event_id=@upcoming_events.event_id@">@upcoming_events.city@</a> - @upcoming_events.timespan@</li>
</multiple>
</ul>
</if>
<else>
<ul><li><em>No Events scheduled for this activity</em></li></ul>
</else>



