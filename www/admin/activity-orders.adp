<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table cellpadding=3>
<tr>
  <th valign=top align=right width="50%">Activity</th>
  <td valign=top width="50%"><a href="activity?activity_id=@activity_id@">@activity_info.name@</a></td>
</tr>
<tr>
  <td colspan=2 align=center>
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

  </td>
</tr>
<tr>
  <td colspan=2>

<if @activity_members:rowcount@ eq 0>
	<ul>
	  <li>No registrants fit this category
	</ul>
</if>

<else>

  <table cellpadding=5>
   <tr>
      <th>Location</th>
      <th>Time</th>
      <th>Reg. ID</th>
      <th>Name</th>
      <th>Email</th>
      <th>Reg. Date</th>
      <th>Reg. State</th>
      <th></th>
   </tr>

    <multiple name=activity_members>
	<tr>
           <td>@activity_members.venue_name@</td>
           <td><a href="event?event_id=@activity_members.event_id@">@activity_members.timespan@</a></td>
           <td><a href="reg-view?reg_id=@activity_members.reg_id@">@activity_members.reg_id@</a></td>
	   <td><a href="order-history-person?user_id=@activity_members.user_id@">@activity_members.name@</a></td>
	   <td><a href="mailto:@activity_members.email@">@activity_members.email@</a></td>
	   <td>@activity_members.creation_date@</td>
           <td>

        <if @activity_members.reg_state@ eq "approved">
        <font color="green">@activity_members.reg_state@</font></td><td>
           <a href="reg-waitlist?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">waitlist</a>
           - <a href="reg-cancel?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">cancel</a> 
        </if>
        <if @activity_members.reg_state@ eq "waiting">
        <font color="blue">@activity_members.reg_state@</font></td><td>
<a href="reg-approve?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">approve</a> -
            <a href="reg-cancel?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">cancel</a> 
        </if>
        <if @activity_members.reg_state@ eq "pending">
        <font color="red">@activity_members.reg_state@</font></td><td>
<a href="reg-approve?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">approve</a> -
            <a href="reg-waitlist?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">waitlist</a>
            - <a href="reg-cancel?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">cancel</a>
        </if>
        <if @activity_members.reg_state@ eq "canceled">
        <font color="gray">@activity_members.reg_state@</font></td><td>
<a href="reg-approve?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">approve</a> -
            <a href="reg-waitlist?reg_id=@activity_members.reg_id@&return_url=activity-orders?activity_id=@activity_id@">waitlist</a>
        </if>

          </td>
	</tr>
    </multiple>
  </table>
</else>

</td></tr></table>
