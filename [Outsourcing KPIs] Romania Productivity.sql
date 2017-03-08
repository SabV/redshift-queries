select *

	from 	(select t.agent,
		
			case when t.action_type = 'new_car_compliance' then 'NCC'
			when t.action_type = 'new_car_quality' then 'NCQ'
			when t.action_type = 'car_photo_quality' then 'CPQ'
			when t.action_type = 'avatar_quality' then 'UPQ'
			when t.action_type = 'suspicious_messages' then 'BS'
			else t.action_type
			end as todo_type,
			
			
			count(t.id), round(avg(t.time_treat::float), 2) as dmt, t.week, t.year
			
				from	(select t.id, u.first_name as agent, datediff(s, convert_timezone('Europe/Paris', s.created_at), convert_timezone('Europe/Paris', e.created_at)) as time_treat, t.action_type, to_char(convert_timezone('Europe/Paris', t.closed_at), 'IW') 						as week, to_char(convert_timezone('Europe/Paris', t.closed_at), 'YYYY') as year
			
							from todos t
							inner join todo_versions s on s.item_id=t.id and s.state_before = 'new' and s.state_after = 'going'
							inner join todo_versions e on e.item_id=t.id and e.state_before = 'going' and e.state_after = 'closed'
							inner join users u on e.whodunnit = u.id
							inner join team_memberships tm on tm.user_id = u.id and tm.name = 'external_quality'
			
								where ((t.action_type in ('new_car_compliance', 'new_car_quality', 'car_photo_quality', 'avatar_quality') and t.country = 'FR' and datediff(s, convert_timezone('Europe/Paris', s.created_at), convert_timezone('Europe/Paris', 									e.created_at)) < 200)
								or (t.action_type = 'suspicious_messages' and t.country='FR' and datediff(s, convert_timezone('Europe/Paris', s.created_at), convert_timezone('Europe/Paris', e.created_at)) < 1000)
								or (t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality') and t.country in ('DE', 'ES', 'AT', 'BE') and datediff(s, convert_timezone('Europe/Paris', s.created_at), convert_timezone('Europe/Paris', 										e.created_at)) < 200))
								and t.state='closed'
								and to_char(convert_timezone('Europe/Paris', t.closed_at), 'YYYY') = 2017
								and to_char(convert_timezone('Europe/Paris', t.closed_at), 'IW') = '09'
			
									group by u.first_name, s.created_at, e.created_at, t.closed_at, t.action_type, t.id)t
			
						group by t.agent, t.action_type, t.week, t.year)u
			
			order by agent asc,
				
			case when todo_type = 'NCC' then '01'
			when todo_type = 'NCQ' then '02'
			when todo_type = 'CPQ' then '03'
			when todo_type = 'UPQ' then '04'
			when todo_type = 'BS' then '05'
			end
;