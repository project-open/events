<master>
<property name="title">Roles</property>
<property name="context_bar">@context_bar;noquote@</property>

<ul>
  <li><a href="role-create">Create a New Role</a></li>
</ul>

<h3>Event Roles</h3>

<if @roles:rowcount@ gt 0>
  <ul>
   <multiple name="roles">
     <li><a href="one-role?role_id=@roles.role_id@">@roles.role@</a> @roles.public_role_p@</li>
   </multiple>
  </ul>
</if>
<else>
  <ul>
   <li>There are no roles defined in the system. You may <a href="role-create">create one now</a>.</li>
  </ul>
</else>


