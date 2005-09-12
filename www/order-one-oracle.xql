<?xml version="1.0"?>
<queryset>

    <fullquery name="select_user_name">
	<querytext>
	declare begin
	 :1 := person.name(person_id => :user_id);
	end;
        </querytext>
    </fullquery>

</queryset>
