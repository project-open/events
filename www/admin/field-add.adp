<master>
<property name="title">@title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<h3>Choose a field (or fields)</h3>
<if @attributes_p@>
<center>
<formtemplate id="field_add"></formtemplate>
</center>
If you do not see the field you wish to add above, you may <a href=@field_create@>add a new field</a>
<p></p>
</if>
<else>
<ul><li>There are no available fields in the system. You may <a href=@field_create@>add a new field</a></li></ul>
</else>
