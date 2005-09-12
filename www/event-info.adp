<master>
<property name="title">@event_info.name;noquote@</property>
<property name="context">@context;noquote@</property>

<h1>@event_info.name;noquote@</h1>

<if @admin_p@ true>
  <div style="float: right; padding: 4px;"><a href="admin/event?event_id=@event_id@" class="button">Administer this event</a></div>
</if>


<table width="70%">
<tr>
  <td class="form-label">When:</td>
  <td class="form-widget">@event_info.timespan@
    <if @event_info.num_other_times@ gt 0>
      <br>
      (<a href="activity?activity_id=@event_info.activity_id@">view other times and locations</a>)</if>
  </td>
</tr>

<tr>
  <td class="form-label">Where/How:</td>
  <td class="form-widget">
    @event_info.city@
    <if @reg_id@ false>
      (You'll get specifics after you register)
    </if>
    <else>
      <if @reg_info.reg_state@ ne "approved">
        (You'll get specifics once your registration has been approved)
      </if>
    </else>
    <if @reg_id@ ne 0 and @reg_info.reg_state@ eq "approved">
        @venue_info.venue_name@
        <if @venue_info.address1@ not nil><br>@venue_info.address1@</if>
        <if @venue_info.address2@ not nil><br>@venue_info.address2@</if>
        <if @venue_info.city@ not nil or @venue_info.usps_abbrev@ not nil>
          <br><if @venue_info.city@ not nil>@venue_info.city@  </if>@venue_info.usps_abbrev@
        </if>

    </if>
  </td>
</tr>

<if @reg_id@ ne 0 and @reg_info.reg_state@ eq "approved" and @venue_info.description@ not nil>
<tr>
  <td class="form-label">Directions:</td>
  <td class="form-widget">
    @venue_info.description@
  </td>
</tr>
</if>

<tr>
  <td class="form-label">Registration:</td>
  <td class="form-widget">

  <if @reg_id@ eq 0>
    <if @reg_deadline_has_passed_p@ true>
      Sorry, the deadline to register for this event was @event_info.reg_deadline@.
    </if>
    <else>
      Deadline is @event_info.reg_deadline@.<br>
      <if @user_id@ ne 0>
        <if @can_register_p@ true>
          <b>&raquo;</b> <a href="order-one?event_id=@event_id@"><b>Register now</b></a>
        </if>
        <else>
          You do not have permission to register for this event.
        </else>
      </if>
      <else>
        <br><b>&raquo;</b> <a href="/register?return_url=@return_url@"><b>Login or sign up</b></a>
        <b>to register for this event.</b>
      </else>
    </else>
  </if>
  <else>
    You have already registered.<br>
    <b>&raquo;</b> <a href="order-check?reg_id=@reg_id@">Check registration status</a>.
  </else>
  </td>
</tr>

<if @organizers:rowcount@ gt 0>
<tr>
  <td class="form-label">Organizers:</td>
  <td class="form-widget">
  <ul>
    <multiple name="organizers">
      <if @organizers.view_url@ not nil>
        <li>@organizers.role@: <a href="@organizers.view_url@">@organizers.organizer_name@</a></li>
      </if>
      <else>
        <li>@organizers.role@: @organizers.organizer_name@</li>
      </else>
    </multiple>
  </ul>

  </td>
</tr>
</if>

<if @attachments_enabled_p@>
<tr>
  <td class="form-label">Event Agenda/Attachments:</td>
  <td class="form-widget">
  <ul>
    <multiple name="attachments">
      <li><a href="@attachments.url@">@attachments.name@</a></li>
    </multiple>
  </ul>
  </td>
</tr>
</if>

<if @event_info.detail_url@ not nil>
<tr>
  <td class="form-label">Related Web Site:</td>
  <td class="form-widget">
    <a href="@event_info.detail_url@">@event_info.detail_url@</a>
  </td>
</tr>
</if>

<if @event_info.additional_note@ not nil>
<tr>
  <td class="form-label">Additional Information:</td>
  <td class="form-widget">

  @event_info.additional_note;noquote@
  
  <if @reg_deadline_has_passed_p@ false and @reg_id@ eq 0>
    <p>
      <if @user_id@ ne 0>
        <if @can_register_p@ true>
          <b>&raquo;</b> <a href="order-one?event_id=@event_id@"><b>Register now</b></a>
        </if>
        <else>
          You do not have permission to register for this event.
        </else>
      </if>
      <else>
        <b>&raquo;</b> <a href="/register?return_url=@return_url@">Login or sign up</a>
        to register for this event.
      </else>
    </if>

  </td>
</tr>
</if>

</table>

