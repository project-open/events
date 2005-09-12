ad_library {
    @author Matthew Geddert (geddert@yahoo.com)
    @creation-date 2002-11-02
}

namespace eval events::time {

    ad_proc -public to_sql_datetime {
        {-datetime:required}
    } {
	This takes a date from a form, and converts it into a format that
        the databases like, i.e.
        YYYY-MM-DD HH24:MM
    } {

        set year [template::util::date::get_property year $datetime]
        set month [template::util::date::get_property month $datetime]
        set day [template::util::date::get_property day $datetime]
        set hours [template::util::date::get_property hours $datetime]
        set minutes [template::util::date::get_property minutes $datetime]
        
	return "$year-$month-$day $hours:$minutes"

    }

}



