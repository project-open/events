<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<if @no_venues@ eq 1>
  <ul><li>There are no venues in the system. You may <a href="venues-ae?return_url=@return_url@">add a new venue</a></li></ul>
</if>

<else>
  <formtemplate id="venue_select"></formtemplate>
  <p>
    If you do not see your venue above, you may <a
    href="venues-ae?return_url=@return_url@">add a new venue</a>.
  </p>
</else>
