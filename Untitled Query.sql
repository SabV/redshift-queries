select *, count(1)

from (select customer_phone_number, to_char(convert_timezone('Europe/Paris', start_time), 'DD-MM-YYYY') as date, phone_display_name, left(ivr_options, 1) as ivr,

CASE WHEN (phone_display_name = 'FR Support'
                                    AND left(ivr_options, 1) <> '1')
                  OR (phone_display_name = 'FR Support'
                      AND ivr_options IS NULL)
                  OR (phone_display_name IN ('FR Open Support',
                                               'FR Owner')) THEN 'FR' WHEN phone_display_name IN ('DE Support',
                                                                                                                'DE Open Support',
                                                                                                                'AT Support',
                                                                                                                'DE Quality') THEN 'DE-AT' WHEN phone_display_name IN ('ES Support',
                                                                                                                                                                         'ES Open Support',
                                                                                                                                                                         'ES Quality') THEN 'ES' WHEN phone_display_name IN ('BE Support') THEN 'BE' ELSE 'ELSE' END AS country
                                                                                                                                                                         
	from talkdesk_calls
	
		where call_type = 'inbound'
		and hangup = 'handled'
		and in_business_hours = 'TRUE'
		and phone_display_name not in ('FR Webhelp > Support', 'FR Webhelp > Open', 'DE Support > Webhelp'))
		
group by customer_phone_number, date, phone_display_name, ivr, country;


select count(1), to_char(convert_timezone('Europe/Paris', ends_at), 'IW')

from rentals

where to_char(convert_timezone('Europe/Paris', ends_at), 'IW') = ---
and to_char(convert_timezone('Europe/Paris', ends_at), 'YYYY') = 2017
and state = 'ended'

group by to_char(convert_timezone('Europe/Paris', ends_at), 'IW')