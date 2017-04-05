select t.id, t.phone_display_name as group, t.agent_name as agent, to_char(convert_timezone('Europe/Paris', t.start_time), 'MM') as month, to_char(convert_timezone('Europe/Paris', t.start_time), 'YYYY') as year

	from talkdesk_calls t
	
		where to_char(convert_timezone('Europe/Paris', t.start_time), 'YYYY') = 2017
		and to_char(convert_timezone('Europe/Paris', t.start_time), 'MM') = '03'

			order by t.start_time asc
;