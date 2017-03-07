select *

	from	(select ztc.id, ztc.ticket_id, ztc.is_public, ztc.channel, u.first_name as agent,
	 					
			case when t.group_id = '25094752' then 'FR Open'
			when t.group_id = '20731033' then 'FR Support'
			when t.group_id = '22929952' then 'FR Quality'
			when t.group_id = '24306629' then 'FR Pro & Power Owners'
			when t.group_id = '26344589' then 'FR Level 1'
			when t.group_id = '24661835' then 'DE Open'
			when t.group_id = '23603861' then 'DE Support'
			when t.group_id = '24478605' then 'DE Quality'
			when t.group_id = '24788545' then 'AT Support'
			when t.group_id = '24527022' then 'ES Support'
			when t.group_id = '24408869' then 'ES Quality'
			when t.group_id = '24902729' then 'ES Open'
			when t.group_id = '26300089' then 'ES Pro & Power Owners'
			when t.group_id = '24808509' then 'BE Support'
			when t.group_id = '26601549' then 'DE Level 1'
			end as group,

			case when tm.name in ('external_support', 'external_quality') then 'Webhelp'
			else 'Drivy'
			end as organisation,
			
			to_char(ztc.created_at, 'DD') as day, to_char(ztc.created_at, 'IW') as week, to_char(ztc.created_at, 'MM') as month, to_char(ztc.created_at, 'YYYY') as year

				from zendesk_ticket_comments ztc
				inner join zendesk_users zu on zu.id = ztc.author_id
				inner join users u on zu.drivy_user_id = u.id
				left join team_memberships tm on tm.user_id = u.id
				inner join 	(select *

							from	(select z.id, z.group_id

									from zendesk_tickets z
									left join (select * from zendesk_ticket_tags zz where zz.tag_name like '%rental_flag%' or zz.tag_name like '%match_flag%' or zz.tag_name like '%car_flag%' or zz.tag_name like '%rental_message_flag%' or zz.tag_name like 											'%rental_message_flags%' or zz.tag_name like '%car_deactivation%' or zz.tag_name like '%sms_failure%' or zz.tag_name like '%car_flags%' or zz.tag_name like '%open_checkin_checkout%' group by zz.tag_name, zz.ticket_id)zt on 										zt.ticket_id = z.id
									left join zendesk_users zu on zu.id = z.submitter_id

										where z.group_id in ('25094752','20731033','22929952','24306629','24661835','23603861','24478605','24788545','24661835','23603861','24478605','24788545','24527022','24408869','24902729','26300089','24808509', '26344589', 										'26601549')
										and (zu.role = 'end-user' or zu.role='agent')
										and zt.ticket_id is null
	
											order by z.created_at asc)t)t on t.id = ztc.ticket_id

				where ztc.is_public is true
				and (zu.role='agent' or zu.role = 'admin'))i
		
		where year = 2017
		and week in = ---
		
			group by i.id, i.ticket_id, i.is_public, i.channel, i.agent, i.group, i.organisation, i.day, i.week, i.month, i.year

				order by year asc, week asc, day asc
