<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>




<table>
   <tr>
     <th colspan=2>Event Information</th>
   </tr>
   <tr>
     <th align="right">Activity:</th>
     <td><a href="activity?activity_id=@event_info.activity_id@">@event_info.name@</a></td> 
   <tr>
   <tr>
     <th align="right">Event:</th>
     <td><a href="event?event_id=@reg_info.event_id@">@venue_info.city@ - @event_info.timespan@</a></td>
   <tr>
   <tr>
     <th colspan=2>Registration Information</th>
   <tr>
   <tr>
     <th align="right">Name:</th>
     <td><a href="order-history-person?user_id=@reg_info.user_id@">@reg_info.user_name@</a></td>
   <tr>
   <tr>
     <th align="right">Email:</th>
     <td><a href="mailto:@reg_info.user_email@">@reg_info.user_email@</a></td>
   <tr>
   <tr>
     <th align="right">Reg. Date:</th>
     <td>@reg_info.creation_date@</td>
   <tr>



   <tr>
     <th align="right">Reg. State:</th>
     <td>
        <if @reg_info.reg_state@ eq "approved">
           <font color="green">approved on @reg_info.approval_date@</font> 
           [ <a href="reg-waitlist?reg_id=@reg_id@">waitlist</a> | 
             <a href="reg-cancel?reg_id=@reg_id@">cancel</a> ]
        </if>
        
        <if @reg_info.reg_state@ eq "waiting">
           <font color="blue">waiting</font> 
           [ 
<if @max_approved@></if><else><a href="reg-approve?reg_id=@reg_id@">approve</a> | </else>
             <a href="reg-cancel?reg_id=@reg_id@">cancel</a> ]
          <if @max_approved@>
            <font color=red>The maximum number of people for this event have already been approved.</font>
          </if>
        </if>


        <if @reg_info.reg_state@ eq "pending">
           <font color="red">pending</font>
           [ 
<if @max_approved@></if><else><a href="reg-approve?reg_id=@reg_id@">approve</a> | </else>
             <a href="reg-waitlist?reg_id=@reg_id@">waitlist</a> | 
             <a href="reg-cancel?reg_id=@reg_id@">cancel</a> ] 
          <if @max_approved@>
            <font color=red>The maximum number of people for this event have already been approved.</font>
          </if>
        </if>

        <if @reg_info.reg_state@ eq "canceled">
           <font color="gray">canceled</font>
        </if>
    </td>
   <tr>


</table>

<formtemplate id="reg_comments"></formtemplate>
