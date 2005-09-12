<master>
<property name="title">Events</property>
<property name="context">@context;noquote@</property>

<if @admin_p@ true>
  <div style="float: right;"><a href="admin/" class="button">Administer Events</a></div>
</if>

<if @events:rowcount@ eq 0>
  <p> No planned events. </p>
</if>
<else>

<h2>Upcoming events at @system_name@.</h2>

  <table cellspacing="8" width="80%">
    <multiple name="events">
      <tr valign="top">
        <td width=180>
          <b>@events.start_date_pretty@</b><br>
          @events.timespan@<br>
	  @events.time_zone@
        </td>
        <td>
          <b><a href="@events.view_url@">@events.name@</a></b>
	  <if "" ne @events.city@>
	    in @events.city@
	  </if>
	  <br>
          @events.description;noquote@
        </td>
      </tr>
    </multiple>
  </table>
</else>
