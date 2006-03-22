<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table>
  <tr>
    <th align=right>Name</th><td>@user_name@</td>
  </tr>
  <tr>
    <th align=right>Email</th><td>@user_email;noquote@</td>
  </tr>
  <tr>
    <th align=right>Community Page</th><td>@member_link;noquote@</td>
  </tr>
</table>

<if @reg_history:rowcount@ eq 0>
	<ul>
	  <li>@user_name@ has not registered for any events
	</ul>
</if>
<else>



  <table cellpadding=4>
   <tr>
      <th>Reg. ID</th>
      <th>Activity</th>
      <th>Event</th>
      <th>Reg. State</th>
      <th></th>
   </tr>

    <multiple name=reg_history>
	<tr>
           <td><a href="reg-view?reg_id=@reg_history.reg_id@">@reg_history.reg_id@</a></td>
	   <td><a href="activity?activity_id=@reg_history.activity_id@">@reg_history.name@</a></td>
	   <td><a href="event?event_id=@reg_history.event_id@">@reg_history.venue_name@ - @reg_history.timespan@</a></td>
           <td>
        <if @reg_history.reg_state@ eq "approved">
        <font color="green">@reg_history.reg_state@</font></td><td>
           <a href="reg-waitlist?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@">waitlist</a>
           - <a href="reg-cancel?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">cancel</a> 
        </if>
        <if @reg_history.reg_state@ eq "waiting">
        <font color="blue">@reg_history.reg_state@</font></td><td>
           <a href="reg-approve?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">approve</a>
           - <a href="reg-cancel?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">cancel</a> 
        </if>
        <if @reg_history.reg_state@ eq "pending">
        <font color="red">@reg_history.reg_state@</font></td><td>
            <a href="reg-approve?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">approve</a>
            - <a href="reg-waitlist?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">waitlist</a>
            - <a href="reg-cancel?reg_id=@reg_history.reg_id@&return_url=order-history-person?user_id=@user_id@
">cancel</a>
        </if>
        <if @reg_history.reg_state@ eq "canceled">
        <font color="gray">canceled</font></td><td>
        </if>

          </td>
	</tr>
    </multiple>
  </table>
</else>

</td></tr></table>
