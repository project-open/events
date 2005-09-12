<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @reg_info.reg_state@ eq "approved">
  <p>
    Your place is reserved.
  </p>
  <p>
    @event_info.display_after@
  </p>

  <if @event_info.reg_cancellable_p@ eq "t">
    <p>
      <b>&raquo;</b> <a href="order-cancel?reg_id=@reg_id@">Cancel your registration</a>.
    </p>
  </if>
</if>

<if @reg_info.reg_state@ eq "pending">
  <p>
    Thank you for your interest in @event_info.name@.
  </p>
  <p>
    Registration for this event requires approval by the event
    organizers.  
  </p>
  <p>
    We will notify you by e-mail as soon as your registrating status
    changes.
  </p>
  <p>
    If you would like to, you may <A href="order-cancel?reg_id=@reg_id@">cancel your request</a>.
  </p>
</if>

<if @reg_info.reg_state@ eq "waiting">
  <p>
    Thank you for your interest in @event_info.name@.
  </p>
  <p>
    Unfortunately, all spaces for this event were filled before you
    applied. Thus, you have been placed on a waiting list.
  </p>
  <p>
    We will notify you by e-mail if your registration status changes.
  </p>
  <p>
    If you would like to, you may <A href="order-cancel?reg_id=@reg_id@">cancel your registration</a>.
  </p>
</if>

<if @reg_info.reg_state@ eq "canceled">
  <p>
    Your registration has been canceled.  If you want, you may
    <a href="order-one?event_id=@reg_info.event_id@">place a new registration</a>.
  </p>
</if>

<p>
  <b>&raquo;</b> <a href="@return_url@">Go back to the event page</a>.
</p>
