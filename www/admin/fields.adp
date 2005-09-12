<master>
<property name="title">Custom Fields</property>
<property name="context_bar">@context_bar;noquote@</property>

<ul>
<li><a href="field-create">Add a New Custom Field</a></li>
</ul>

<h3>Custom Fields</h3>
You may define custom fields that you would like to collect from registrants.
<if @custom_fields:rowcount@ gt 0>
<p></p>
Custom fields currently in the system:
<multiple name="custom_fields">
<ul>
<h4>@custom_fields.category_name@</h4>
<group column="category_name">
<li><a href="field?attribute_id=@custom_fields.attribute_id@">@custom_fields.name@</a> (@custom_fields.datatype@) 
</group>
</ul>
</multiple>
</ul>
</if>
<else>
<p>
<ul>
<li>There are no custom fields in the system. You may <a href="field-create">add a new one</a></li>
</ul>
</else>
