<master>
<property name="title">@title;noquote@</property>
<property name="context_bar">@context;noquote@</property>

<h3>Venue Description</h3>

<formtemplate id="venues_ae"></formtemplate>

<if @in_use_p@ false>
  <h3>Delete this Venue</h3>
  <ul><li>You may also <a href="venue-delete?venue_id=@venue_id@">delete this venue</a></li></ul>
</if>
