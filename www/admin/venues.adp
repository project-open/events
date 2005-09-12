<master>
<property name="title">Venues</property>
<property name="context_bar">@context_bar;noquote@</property>

<ul>
<li><a href="venues-ae">Add a New Venue</a>
<if @venue_id@ ne ""><li><a href="venues">Top Level Venues</a></if>
</ul>

<h3>Venues</h3>

<if @venue_id@ ne ""><h3><if @parent_p@>Parents</if><else>Children</else> of Venue&nbsp;:&nbsp;@venue_name@</h3></if>

@table;noquote@
