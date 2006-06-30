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

<table width=70%>
<tr><td>
<p>
All of these events are online web seminars. Shortly before each seminar we will
send you an email with the URL of a chat room and a telephone number of a 
teleconference provider.<br>
In the chat room we will publish ("push") the URLs of our PowerPoint slides
and of the online application. In the teleconf room we are going to provide
you with an "audio track", explaining the PowerPoint slides and guiding you
though the online application.
</p>
</td></tr>
</table>

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


<table width=70%>
<tr><td>
<p>
Please 
<a href="mailto:info@project-open.com?subject=Web%20Conference%20Registration">let us know</a>
if you would like to participate in a web seminar on a different
day or at a different time.<br>

<!--
Please note that half of the seminars above are held at 11 am
CEST (Central European Summer Time), while the other half is held
at 11 am EST (Eastern Standard Time).
-->

</p>
</td></tr>
</table>
