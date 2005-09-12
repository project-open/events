<master>
<property name="title">Register for @event_info.name@</property>
<property name="context">@context;noquote@</property>

<p>
  Register for @event_info.name@ on @event_info.timespan@ in @event_info.city@.
</p>

<if @reg_notes:rowcount@ gt 0>
  <p><b>Note:</b></p>
  <ul>
    <multiple name="reg_notes">
      <li>@reg_notes.note@</li>
    </multiple>
  </ul>
</if>

<formtemplate id="registration"></formtemplate>
