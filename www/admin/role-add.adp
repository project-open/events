<master>
<property name="title">@title;noquote@</property>
<property name="context_bar">@context_bar;noquote@</property>

<h3>Choose a role (or roles)</h3>
<if @roles_p@>
<center>
<formtemplate id="role_add"></formtemplate>
</center>
If you do not see the role you wish to add above, you may <a href=@role_create@>add a new role</a>
<p></p>
</if>
<else>
<ul><li>There are no available roles in the system. You may <a href=@role_create@>add a new role</a></li></ul>
</else>
