select *

	from

	(select z.id, zu.drivy_user_id, u.behavior, z.submitter_id, z.email, ztm.nb_replies, ztm.reply_time_minutes_business, a.first_name as agent,

	case when z.group_id = '25094752' then 'FR Open'
	when z.group_id = '20731033' then 'FR Support'
	when z.group_id = '22929952' then 'FR Quality'
	when z.group_id = '24306629' then 'FR Pro & Power Owners'
	when z.group_id = '26344589' then 'FR Level 1'
	when z.group_id = '24661835' then 'DE Open'
	when z.group_id = '23603861' then 'DE Support'
	when z.group_id = '24478605' then 'DE Quality'
	when z.group_id = '24788545' then 'AT Support'
	when z.group_id = '24527022' then 'ES Support'
	when z.group_id = '24408869' then 'ES Quality'
	when z.group_id = '24902729' then 'ES Open'
	when z.group_id = '26300089' then 'ES Pro & Power Owners'
	when z.group_id = '24808509' then 'BE Support'
	when z.group_id = '26601549' then 'DE Level 1'
	end as group,

	case when z.group_id = '26344589' then 'Webhelp'
	when z.group_id = '26601549' then 'Webhelp'
	else 'Drivy'
	end as organisation,

	zu.role = 'end-user' as submitter_is_user, to_char(z.created_at, 'DD') as day,

	case when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') <= 52 then to_char(dateadd(week, 1, z.created_at), 'IW')
	when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') > 52 then '01'
	else to_char(z.created_at, 'IW')
	end as week,

	case when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') > 52 then '01'
	else to_char(z.created_at, 'MM')
	end as month,

	case when to_char(z.created_at, 'D') in (6,7,1) and to_char(dateadd(week, 1, z.created_at), 'IW') > 52 then
	to_char(dateadd(year,1,z.created_at), 'YYYY')
	else to_char(z.created_at, 'YYYY')
	end as year

		from zendesk_tickets z
		left join (select * from zendesk_ticket_tags zz where zz.tag_name like '%rental_flag%' or zz.tag_name like '%match_flag%' or zz.tag_name like '%car_flag%' or zz.tag_name like '%rental_message_flag%' or zz.tag_name like '%rental_message_flags%' or 				zz.tag_name like '%car_deactivation%' or zz.tag_name like '%sms_failure%' or zz.tag_name like '%car_flags%' or zz.tag_name like '%open_checkin_checkout%' group by zz.tag_name, zz.ticket_id)zt on zt.ticket_id=z.id
		left join zendesk_users zu on zu.id=z.submitter_id
		left join zendesk_users za on za.id=z.assignee_id
		left join zendesk_ticket_metrics ztm on ztm.ticket_id=z.id
		left join users u on u.id=zu.drivy_user_id
		left join users a on a.id=za.drivy_user_id

			where z.group_id in ('25094752','20731033','22929952','24306629','24661835','23603861','24478605','24788545','24661835','23603861','24478605','24788545','24527022','24408869','24902729','26300089','24808509', '26344589', '26601549')
			and (zu.role = 'end-user' or zu.role='agent')
			and zt.ticket_id is null

				order by z.created_at asc)t

	where t.year = 2017
	and t.week = ---