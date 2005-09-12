<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table cellpadding=3>
<tr>
  <th valign=top align=right width="50%">Activity</th>
  <td valign=top width="50%"><a href="activity?activity_id=@event_info.activity_id@">@event_info.name@</a></td>
</tr>
<tr>
  <th valign=top align=right>Location</th>
  <td valign=top>@event_info.city@</a></td>
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
 <td colspan=2 valign=top align=center>
        <table border=0 cellpadding=3>
            <tr>
                <td align="center">Max Allowed</td>
                <th>Spots Remaining</th>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=approved"><font color="green">Approved</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=pending"><font color="red">Pending</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=waiting"><font color="blue">Waiting</font></a></td>
                <td align="center"><a href="event-orders?event_id=@event_id@&specific_reg_type=canceled"><font color="gray">Canceled</font></a></td>
            </tr>  
            <tr>
                <td align="center"><if @event_stats.max_people@ eq "">N/A</if><else>@event_stats.max_people@</else></td>
                <th><if @event_stats.max_people@ eq ""><b>N/A</b></if><else>@count_spotsremaining@</else>
                <td align="center"><font color="green">@event_stats.approved@</a></td>
                <td align="center"><font color="red">@event_stats.pending@</a></td>
                <td align="center"><font color="blue">@event_stats.waiting@</a></td>
                <td align="center"><font color="gray">@event_stats.canceled@</a></td>
            </tr>
        </table>
<if @max_approved@>
    <p>
    <font color=red>The maximum number of people allowed have been registered for this event.<br>
                    You cannot approve users unless you waitlist or cancel somebody<br>
                    else's registration (or modify the maximum capacity of this this event)</font>
</if>

</td>
</tr>
<tr><td colspan=2>



<if @event_members:rowcount@ eq 0>
	<ul>
	  <li>No registrants fit this category
	</ul>
</if>

<else>

  <table cellpadding=5>
   <tr>
      <th>Reg. ID</th>
      <th>Name</th>
      <th>Email</th>
      <th>Reg. Date</th>
      <th>Reg. State</th>
      <th></th>
   </tr>

    <multiple name=event_members>
	<tr>
           <td><a href="reg-view?reg_id=@event_members.reg_id@">@event_members.reg_id@</a></td>
	   <td><a href="order-history-person?user_id=@event_members.user_id@">@event_members.name@</a></td>
	   <td><a href="mailto:@event_members.email@">@event_members.email@</a></td>
	   <td>@event_members.creation_date@</td>
           <td>
        <if @event_members.reg_state@ eq "approved">
        <font color="green">@event_members.reg_state@</font></td><td>
           <a href="reg-waitlist?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">waitlist</a>
           - <a href="reg-cancel?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">cancel</a> 
        </if>
        <if @event_members.reg_state@ eq "waiting">
        <font color="blue">@event_members.reg_state@</font></td><td>
<if @max_approved@></if><else><a href="reg-approve?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">approve</a> -</else>
            <a href="reg-cancel?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">cancel</a> 
        </if>
        <if @event_members.reg_state@ eq "pending">
        <font color="red">@event_members.reg_state@</font></td><td>
<if @max_approved@></if><else><a href="reg-approve?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">approve</a> -</else>
            <a href="reg-waitlist?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">waitlist</a>
            - <a href="reg-cancel?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">cancel</a>
        </if>
        <if @event_members.reg_state@ eq "canceled">
        <font color="gray">@event_members.reg_state@</font></td><td>
<if @max_approved@></if><else><a href="reg-approve?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">approve</a> -</else>
            <a href="reg-waitlist?reg_id=@event_members.reg_id@&return_url=event-orders?event_id=@event_id@">waitlist</a>
        </if>

          </td>
	</tr>
    </multiple>
  </table>
</else>

</td></tr></table>
