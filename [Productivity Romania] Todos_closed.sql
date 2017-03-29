select *

	from (
	
	--- CLOSED BY THEM
	
			select *, 'closed' as action
			
				from 	(select t.agent,
					
						case when t.action_type = 'new_car_compliance' then 'NCC'
						when t.action_type = 'new_car_quality' then 'NCQ'
						when t.action_type = 'car_photo_quality' then 'CPQ'
						when t.action_type = 'avatar_quality' then 'UPQ'
						when t.action_type = 'suspicious_messages' then 'BS'
						else t.action_type
						end as todo_type,
						
						
						count(distinct(t.id)) as count, t.week, t.year
						
							from	(select t.id, u.first_name as agent, t.action_type, to_char(convert_timezone('Europe/Bucharest', t.closed_at), 'IW') as week, to_char(convert_timezone('Europe/Bucharest', t.closed_at), 'YYYY') as year
						
										from todos t
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = e.whodunnit
										inner join team_memberships tm on tm.user_id = e.whodunnit and tm.name = 'external_quality'
						
											where (t.action_type in ('new_car_compliance', 'new_car_quality', 'car_photo_quality', 'avatar_quality', 'suspicious_messages') and t.country = 'FR')
											or (t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality') and t.country in ('DE', 'ES', 'AT', 'BE'))
											
											and t.state='closed'
			
												group by u.first_name, e.created_at, t.closed_at, t.action_type, t.id)t
						
									group by t.agent, t.action_type, t.week, t.year)u
						
					where year = 2017
					and week = ---		
	
UNION
	
	--- CLOSED BY US - ASSIGNED BY THEM
	
			select *, 'assigned' as action
			
				from 	(select t.agent,
					
						case when t.action_type = 'new_car_compliance' then 'NCC'
						when t.action_type = 'new_car_quality' then 'NCQ'
						when t.action_type = 'car_photo_quality' then 'CPQ'
						when t.action_type = 'avatar_quality' then 'UPQ'
						when t.action_type = 'suspicious_messages' then 'BS'
						else t.action_type
						end as todo_type,
						
						
						count(distinct(t.id)) as count, t.week, t.year
						
							from	(select t.id, u.first_name as agent, t.action_type, to_char(convert_timezone('Europe/Bucharest', t.closed_at), 'IW') as week, to_char(convert_timezone('Europe/Bucharest', t.closed_at), 'YYYY') as year
						
										from todos t
										inner join todo_versions g on g.item_id = t.id and g.state_before = 'going' and g.state_after = 'going'
										inner join todo_versions e on e.item_id = t.id and e.state_before = 'going' and e.state_after = 'closed'
										inner join users u on u.id = g.whodunnit
										inner join users uc on uc.id = g.user_id_after and uc.is_admin = 1
										inner join team_memberships tm on tm.user_id = g.whodunnit and tm.name = 'external_quality'
						
											where (t.action_type in ('new_car_compliance', 'new_car_quality', 'car_photo_quality', 'avatar_quality', 'suspicious_messages') and t.country = 'FR')
											or (t.action_type in ('new_car_compliance', 'car_photo_quality', 'avatar_quality') and t.country in ('DE', 'ES', 'AT', 'BE'))
											
											and t.state='closed'
			
												group by u.first_name, e.created_at, t.closed_at, t.action_type, t.id)t
						
									group by t.agent, t.action_type, t.week, t.year)u
						
					where year = 2017
					and week = ---
					)f
				
		order by year asc, week asc, agent asc,
					
		case when todo_type = 'NCC' then '01'
		when todo_type = 'NCQ' then '02'
		when todo_type = 'CPQ' then '03'
		when todo_type = 'UPQ' then '04'
		when todo_type = 'BS' then '05'
		end
;
